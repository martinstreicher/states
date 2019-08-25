# frozen_string_literal: true

RSpec.describe Program do
  include_context 'with an active record model', class_name: 'Widget'

  before do
    exception_class = Class.new(RuntimeError)

    widget_program =
      Class.new(described_class) do
        plan do
          step :a
          step :b, retries: [10.minutes, 15.minutes]
        end

        def before_a; end

        def before_b; end

        def before_b_retry_one; end

        def before_b_retry_two; end

        def before_start; end
      end

    stub_const 'WidgetProgram', widget_program
    stub_const 'TestException', exception_class
  end

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

      it 'calls the proper callback for transition to b_retry_one' do
        model.transition_to :start
        model.transition_to :a
        model.transition_to :b

        allow(state_machine).to receive(:before_b_retry_one)
        model.transition_to :b_retry_one
        expect(state_machine).to have_received(:before_b_retry_one)
      end

      it 'does not callback if the handler does not exist' do
        model.transition_to :start
        model.transition_to :a
        model.transition_to :b

        expect(model.transition_to(:finish)).to be_truthy
      end
    end
  end
end
