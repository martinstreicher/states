# frozen_string_literal: true

RSpec.describe Program do
  before do
    exception_class = Class.new(RuntimeError)

    states_test_program =
      Class.new(described_class) do
        plan do
          step :a
          step :b, retries: [10.minutes, 15.minutes]
        end
      end

    stub_const 'StatesTestProgram', states_test_program
    stub_const 'TestException', exception_class
  end

  let(:machine_class) { StatesTestProgram }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }

  describe 'Class Methods' do
    describe '.plan' do
      it 'creates a transition from :start to the first state' do
        expect(transitions.start).to include('a')
        expect(transitions.a).to match_array(%w[b expire finish])
        expect(transitions.b).to match_array(%w[b_retry_one expire finish])
        expect(transitions.b_retry_one).to match_array(%w[b_retry_two expire finish])
      end
    end
  end

  describe 'Instance Methods' do
    subject(:machine) { machine_class.new }

    describe '#states' do
      it 'includes the list of pre-defined states' do
        expect(machine.states).to include('expire', 'finish', 'start')
      end

      it 'includes the list of defined states' do
        expect(machine.states).to include('a', 'b')
      end

      it 'includes the list of derived states' do
        expect(machine.states).to include('b_retry_one', 'b_retry_two')
      end
    end

    describe 'transitions' do
      it 'includes paths via the pre-defined states' do
        expect(transitions.pending).to match_array(%w[start])
        expect(transitions.start).to include('expire', 'finish')
      end

      it 'includes paths between the defined states' do
        expect(transitions.start).to include('a')
        expect(transitions.a).to match_array(%w[b expire finish])
      end

      it 'includes paths via the derived states' do
        expect(transitions.b).to match_array(%w[b_retry_one expire finish])
        expect(transitions.b_retry_one).to match_array(%w[b_retry_two expire finish])
        expect(transitions.b_retry_two).to match_array(%w[expire finish])
      end
    end
  end
end
