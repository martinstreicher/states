class StateMachine
  include Statesman::Machine
  include Statesman::Events

  def self.inherited(subclass)
    subclass.instance_eval do
      state :pending, initial: true
      state :expired
      state :finished
      state :started

      transition from: :pending, to: :started
      transition from: :started, to: %i[expired finished]

      before_transition(to: :finished) do |record, transition|
        record.finished transition
      end

      before_transition(from: :pending, to: :started) do |record, transition|
        record.start transition
      end

      before_transition(to: :expired) do |record, transition|
        record.expired transition
      end
    end
  end
end
