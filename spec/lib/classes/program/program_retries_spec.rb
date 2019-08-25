# frozen_string_literal: true

RSpec.describe Program do
  include_context 'with an active record model', class_name: 'Gizmo'

  before do
    exception_class = Class.new(RuntimeError)

    gizmo_program_class =
      Class.new(described_class) do
        plan do
          step :a
          step :b, expiry: 30.minutes, retries: [1.hour, 2.hours]
        end
      end

    stub_const 'GizmoProgram', gizmo_program_class
    stub_const 'TestException', exception_class
  end

  let(:now) { Time.zone.now }

  describe 'Timing' do
    context 'when the state is a `major` state' do
      it 'assigns an expire_at time' do
        Timecop.freeze(now) do
          model.transition_to :start
          model.transition_to :a
        end

        state = model.transitions.find_by(most_recent: true)
        expect(state.expire_at).to eq(now + 12.hours)
        expect(state.transition_at).to be_nil
      end
    end

    context 'when the state is a `minor` state' do
      it 'assigns a transition_at time to the first attempt ' do
        Timecop.freeze(now) do
          model.transition_to :start
          model.transition_to :a
          model.transition_to :b
        end

        state = model.transitions.find_by(most_recent: true)
        expect(state.to_state).to eq('b')
        expect(state.transition_at).to eq(now + 1.hour)
        expect(state.expire_at).to eq(now + 30.minutes)
      end

      it 'assigns a transition_at time to the second attempt (first retry)' do
        Timecop.freeze(now) do
          model.transition_to :start
          model.transition_to :a
          model.transition_to :b
          model.transition_to :b_retry_one
        end

        state = model.transitions.find_by(most_recent: true)
        expect(state.to_state).to eq('b_retry_one')
        expect(state.transition_at).to eq(now + 2.hours)
        expect(state.expire_at).to eq(now + 30.minutes)
      end

      it 'assigns a transition_at time to the third attempt (second retry)' do
        Timecop.freeze(now) do
          model.transition_to :start
          model.transition_to :a
          model.transition_to :b
          model.transition_to :b_retry_one
          model.transition_to :b_retry_two
        end

        state = model.transitions.find_by(most_recent: true)
        expect(state.to_state).to eq('b_retry_two')
        expect(state.transition_at).to eq(now + 12.hours)
        expect(state.expire_at).to eq(now + 30.minutes)
      end
    end
  end
end
