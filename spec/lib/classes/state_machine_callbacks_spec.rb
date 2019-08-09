# frozen_string_literal: true

RSpec.describe StateMachine do
  # rubocop:disable RSpec/LeakyConstantDeclaration

  include_context 'with an active record model'

  class WidgetStateMachine < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a
      step :b, retries: [10.minutes, 15.minutes]
    end

    def before_a
      puts 'Before a'
    end

    def before_b
      raise 'Before b'
    end

    def before_b_retry_one
      raise 'Before b retry one'
    end

    def before_b_retry_two
      raise 'Before b retry two'
    end

    def before_start
      'Before start'
    end
  end

  let(:machine_class) { WidgetStateMachine }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }

  describe 'Callbacks' do
    context 'when transitioning to a state' do
      it 'calls the proper callback for start' do
        allow(state_machine).to receive(:before_start)
        model.transition_to :start
        expect(state_machine).to have_received(:before_start)
      end

      it 'calls the proper callback for transition to a' do
        model.transition_to :start
        allow(state_machine).to receive(:before_a)
        model.transition_to :a
        expect(state_machine).to have_received(:before_a)
      end

      it 'calls the proper callback for transition to b' do
        model.transition_to :start
        model.transition_to :a
        allow(state_machine).to receive(:before_b)
        model.transition_to :b
        expect(state_machine).to have_received(:before_b)
      end
    end
  end

  # rubocop:enable RSpec/LeakyConstantDeclaration
end
