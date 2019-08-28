# frozen_string_literal: true

RSpec.describe Transition do
  include_context 'with an active record model', class_name: 'Sprocket'

  describe 'Scopes' do
    before do
      exception_class = Class.new(RuntimeError)

      sprocket_program_class =
        Class.new(Program) do
          program do
            step :a
            step :b, expiry: 3.hours, retries: [1.hour, 2.hours]
          end
        end

      stub_const 'SprocketProgram', sprocket_program_class
      stub_const 'TestException', exception_class
    end

    let(:now) { Time.zone.now }

    context 'with #scheduled_to_expire' do
      it 'finds models about to expire' do
        another_model = klass.new name: 'Sprocket'
        another_model.transition_to :start
        model.transition_to :start
        model.transition_to :a
        expect(klass.scheduled_to_expire(at: now + 12.hours)).to match_array([model])
      end
    end

    context 'with #scheduled_to_transition' do
      it 'finds models that must be advanced' do
        another_model = klass.new name: 'Sprocket'
        another_model.transition_to :start
        model.transition_to :start
        model.transition_to :a
        model.transition_to :b
        expect(klass.scheduled_to_transition(at: now + 1.hour)).to match_array([model])
        model.transition_to :b_retry_one
        expect(klass.scheduled_to_transition(at: now + 2.hours)).to match_array([model])
      end
    end
  end
end
