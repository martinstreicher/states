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

    def self.call_if_defined(method_name, record, transition = nil)
      return true unless record.respond_to?(method_name)

      args = [method_name, record]
      args.push(transition) if transition
      send(*args)
    end

    def self.plan(options = {}, &block)
      @states_cache = []

      raise ArgumentError.new('no block provided') unless block_given?

      yield

      modified_options = options.symbolize_keys
      end_state        = modified_options.fetch :to, :finish
      start_state      = modified_options.fetch :from, :start

      instance_eval do
        transition from: start_state, to: @states_cache.first
        transition from: @states_cache.last, to: end_state

        @states_cache.each_with_index do |state, index|
          current_state = @states_cache[index]
          next_state    = @states_cache[index + 1]
          break if next_state.nil?

          transition from: current_state, to: next_state

          after_transition(to: current_state) do |record, transition|
            call_if_defined "after_#{current_state}", record, transition
          end

          before_transition(to: current_state) do |record, transition|
            call_if_defined "before_#{current_state}", record, transition
          end

          guard_transition(to: current_state) do |record|
            call_if_defined "guard_#{current_state}", record
          end
        end
      end
    end

    def self.step(*names)
      (@states_cache ||= []).push(*names)

      names.each do |name|
        instance_eval do
          state name
        end
      end
    end

    def states
      self.class.states
    end
  end
end
