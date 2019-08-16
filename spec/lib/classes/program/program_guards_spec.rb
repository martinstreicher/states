# frozen_string_literal: true

RSpec.describe Program do
  include_context 'with an active record model', class_name: 'Gadget'

  # rubocop:disable RSpec/LeakyConstantDeclaration

  class GadgetProgram < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a
      step :b
    end

    def can_transition_to_a?; end
  end

  # rubocop:enable RSpec/LeakyConstantDeclaration

  describe 'Guards' do
    context 'when no guard method exists' do
      it 'advances state unconditionally' do
        model.transition_to :start
        allow(state_machine).to(receive(:can_transition_to_a?).and_return(true))
        model.transition_to :a
        model.transition_to :b
        expect(model.current_state).to eq('b')
      end
    end

    context 'when guard method responds true' do
      it 'changes state' do
        model.transition_to :start
        allow(state_machine).to(receive(:can_transition_to_a?).and_return(true))
        model.transition_to :a
        expect(state_machine).to(have_received(:can_transition_to_a?))
        expect(model.current_state).to eq('a')
      end
    end

    context 'when guard method responds false' do
      it 'changes state' do
        model.transition_to :start
        allow(state_machine).to(receive(:can_transition_to_a?).and_return(false))
        model.transition_to :a
        expect(model.current_state).to eq('start')
      end
    end
  end
end
