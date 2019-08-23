# frozen_string_literal: true

module Internals
  module Transitions
    private

    def add_major_transitions(current_state, next_state)
      transition from: current_state, to: next_state
      add_callbacks_and_guards next_state
    end

    def add_minor_transitions(previous_state, next_state)
      current_state = previous_state
      next_retry    = nil
      retries       = (states_cache[previous_state] || {})[:retries]
      retries     ||= []

      retries.each_with_index do |_offset, index|
        next_retry = "#{previous_state}_retry_#{(index + 1).humanize}"

        state next_retry
        transition from: current_state, to: next_retry
        transition from: next_retry,    to: next_state

        add_callbacks_and_guards next_retry, next_state
        break if retries[index + 1].nil?

        current_state = next_retry
      end
    end

    def add_transitions(current_state, next_state)
      add_major_transitions current_state, next_state
      add_minor_transitions current_state, next_state
    end
  end
end
