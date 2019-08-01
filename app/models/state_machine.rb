class StateMachine
  include Statesman::Machine
  include Statesman::Events

  def self.inherited(subclass)
    subclass.instance_eval do
      state :expire
      state :finish
      state :pending, initial: true
      state :start

      transition from: :pending, to: :start
      transition from: :start,   to: %i[expire finish]

      before_transition(to: :finish) do |record, transition|
        record.finish(transition) if record.respond_to?(:finish)
      end

      before_transition(from: :pending, to: :start) do |record, transition|
        record.start(transition) if record.respond_to?(:start)
      end

      before_transition(to: :expire) do |record, transition|
        record.expire(transition)  if record.respond_to?(:expire)
      end
    end

    def self.plan(options = {}, &block)
      raise ArgumentError.new('no block provided') unless block_given?

      previous_states  = @states_cache&.clone || []

      yield

      new_states       = @states_cache - previous_states
      modified_options = options.symbolize_keys
      end_state        = modified_options.fetch :to, :finish
      start_state      = modified_options.fetch :from, :start

      instance_eval do

      end
    end

    def self.step(*names)
      (@states_cache ||= []).push(*names)

      names.each do |name|
        instance_eval do
          state name
          transition from: :pending, to: name

          before_transition(to: name) do |record, transition|
            method_to_call = "step_#{name}"

            send(method_to_call, record, transition) if
              record.respond_to?(method_to_call)
          end
        end
      end
    end

    def states
      self.class.states
    end
  end
end
