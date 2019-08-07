# frozen_string_literal: true

RSpec.describe StateMachine do
  # rubocop:disable RSpec/LeakyConstantDeclaration

  class TestMachine < described_class
    TestException = Class.new(RuntimeError)

    plan do
      step :a
      step :b, retries: [10.minutes, 15.minutes]
    end

    def before_a
      raise TestException, 'Before a'
    end
  end

  let(:machine_class) { TestMachine }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }

  describe 'Class Methods' do
    describe '.plan' do
      it 'creates a transition from :start to the first state' do
        expect(transitions.start).to include('a')
        expect(transitions.a).to match_array(%w[b])
        expect(transitions.b).to match_array(["b_attempt_#{10.minutes}", 'expire', 'finish'])
        expect(transitions.b_attempt_600).to match_array(["b_attempt_#{15.minutes}", 'expire', 'finish'])
      end
    end
  end

  describe 'Instance Methods' do
    subject(:machine) { TestMachine.new }

    describe '#states' do
      it 'returns a list of all states' do
        expect(machine.states).to include('a', 'b')
      end
    end
  end

  describe 'Internal Operations' do
    it 'define :start, :finish, and :expire' do
      expect(transitions.start).to include('expire', 'finish')
    end
  end

  # rubocop:enable RSpec/LeakyConstantDeclaration
end
