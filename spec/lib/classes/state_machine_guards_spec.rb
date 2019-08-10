# frozen_string_literal: true

RSpec.describe StateMachine do
  include_context 'with an active record model', class_name: 'Gadget'

  # rubocop:disable RSpec/LeakyConstantDeclaration

  class GadgetStateMachine < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a
      step :b
    end

    def can_transition_to_a?; end

    def can_transition_to_b?; end
  end

  # rubocop:enable RSpec/LeakyConstantDeclaration

  describe 'Guards' do
    context 'when can_transition_to*? responds true' do
      it 'changes state' do
        model.transition_to :start
        allow(state_machine).to(receive(:can_transition_to_a?).and_return(true))
        model.transition_to :a
        expect(state_machine).to(have_received(:can_transition_to_a?))
        expect(model.current_state).to eq('a')
      end
    end

    context 'when can_transition_to_*? responds false' do
      it 'changes state' do
        model.transition_to :start
        allow(state_machine).to(receive(:can_transition_to_a?).and_return(false))
        model.transition_to :a
        expect(model.current_state).to eq('start')
      end
    end
  end
end
