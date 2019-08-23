# frozen_string_literal: true

module Internals
  module Callbacks
    def call_if_defined(method_name, record, transition = nil)
      state_machine = record.state_machine
      return true unless state_machine.respond_to?(method_name)

      arity = state_machine.method(method_name).arity
      args = []
      args.push(record) if arity >= 1
      args.push(transition) if (arity == 2) && transition
      state_machine.send(method_name, *args)
    end

    private

    def add_callbacks_and_guards(*state_names)
      filtered_state_names = state_names.flatten.map(&:to_sym) - Program::PREDEFINED_STATES

      filtered_state_names.each do |state_name|
        after_transition(to: state_name, after_commit: true) do |record, transition|
          call_if_defined "after_#{state_name}", record, transition
        end

        before_transition(to: state_name) do |record, transition|
          send :before, record, transition
          call_if_defined "before_#{state_name}", record, transition
          call_if_defined state_name, record, transition
        end

        guard_transition(to: state_name) do |record|
          call_if_defined "can_transition_to_#{state_name}?", record
        end
      end
    end

    def before(record, transition)
      options = states_cache.fetch transition.effective_state.to_sym, {}

      return(before_minor_state(record, transition)) if
        transition.retry? || options.key?(:retries)

      before_major_state record, transition
    end

    def before_major_state(_record, transition)
      options = states_cache.fetch transition.effective_state.to_sym, {}
      expiry  = options.fetch :expiry, nil
      transition.expire_at = Time.now.utc + (expiry || 12.hours)
    end

    def before_minor_state(record, transition)
      first_attempt_at =
        record
        .transitions
        .find_by(to_state: record.current_state)
        .created_at

      attempt_no               = transition.attempt
      options                  = states_cache.fetch transition.effective_state.to_sym, {}
      delay                    = options.fetch(:retries, [])[attempt_no] # 1st -> 0, 2nd -> 1...
      expiry                   = options.fetch :expiry, nil
      transition.expire_at     = Time.now.utc + expiry if expiry
      transition.transition_at = first_attempt_at + (delay || 12.hours)
    end
  end
end
