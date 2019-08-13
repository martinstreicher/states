# frozen_string_literal: true

RSpec.describe StateMachine do
  # rubocop:disable RSpec/LeakyConstantDeclaration
  class DatTestMachine < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a, retries: [1.hour, 2.hours]
      step :b, retries: [10.minutes, 15.minutes]
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration

  let(:machine)       { machine_class.new }
  let(:machine_class) { DatTestMachine }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }

  describe 'States and Transitions' do
    it 'defines all the proper states' do
      expected_states = %w[a b a_retry_one a_retry_two b_retry_one b_retry_two]
      expect(machine.states).to(include(*expected_states))
    end
  end
end
