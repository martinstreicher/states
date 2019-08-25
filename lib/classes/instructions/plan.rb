# frozen_string_literal: true

module Instructions
  module Plan
    def plan(options = {}) # rubocop:disable Metrics/AbcSize
      raise ArgumentError, 'no block provided' unless block_given?

      self.states_cache = {}
      yield
      options = options.symbolize_keys
      end_state = options.fetch :to, Program::END_STATES
      start_state = options.fetch :from, Program::START_STATE

      instance_eval do
        state_names = [start_state, *states_cache.keys]

        state_names.each_with_index do |_state, index|
          current_state = state_names[index]
          next_state    = Array(state_names[index + 1] || [])
          next_state   += end_state unless current_state == :start
          add_transitions current_state, next_state

          break if next_state.nil?
        end
      end
    end

    alias program plan
  end
end
