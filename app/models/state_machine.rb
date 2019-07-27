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

    def self.steps(*names)
      names.each do |name|
        instance_eval do
          state name

          transition from: :pending, to: name

          before_transition(to: name) do |record, transition|
            send("step_#{name}", record, transition)
          end
        end
      end
    end
  end
end
