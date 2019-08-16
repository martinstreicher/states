# frozen_string_literal: true

RSpec.describe Program do
  # rubocop:disable RSpec/LeakyConstantDeclaration
  class DatTestProgram < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a, retries: [1.hour, 2.hours]
      step :b, retries: [10.minutes, 15.minutes]
    end
  end
  # rubocop:enable RSpec/LeakyConstantDeclaration

  let(:machine)       { machine_class.new }
  let(:machine_class) { DatTestProgram }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }

  describe 'States and Transitions' do
    it 'defines the proper states' do
      expected_states   = %w[a b a_retry_one a_retry_two b_retry_one b_retry_two]
      predefined_states = %w[expire finish start]
      expect(machine.states).to(
        include(*expected_states) && include(*predefined_states)
      )
    end

    it 'defines the proper transitions' do
      ap transitions
      expect(transitions.a).to(include('b', 'a_retry_one', 'expire'))
      expect(transitions.b).to(include('finish', 'b_retry_one', 'expire'))
    end
  end
end
