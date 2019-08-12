# frozen_string_literal: true

class StateMachine
  include Statesman::Machine
  include Statesman::Events

  END_STATES        = %i[expire finish].freeze
  START_STATE       = :start
  PREDEFINED_STATES = [START_STATE, *END_STATES].freeze

  delegate_missing_to :object

  def initialize(instance = nil, association_name: :transitions, transition_class: Transition)
    super(
      instance,
      association_name: association_name,
      transition_class: transition_class
    )
  end

  # rubocop:disable Lint/NestedMethodDefinition, Metrics/AbcSize, Metrics/MethodLength

  def self.inherited(subclass)
    subclass.extend ClassMethods

    subclass.instance_eval do
      class_attribute :states_cache, instance_writer: false, default: {}

      PREDEFINED_STATES.each { |state_name| state state_name }
      state :pending, initial: true
      transition from: :pending, to: START_STATE
      transition from: START_STATE, to: END_STATES

      PREDEFINED_STATES.each do |state_name|
        before_transition(to: state_name) do |record, transition|
          call_if_defined "before_#{state_name}", record, transition
        end

        guard_transition(to: state_name) do |record, transition|
          call_if_defined "can_transition_to_#{state_name}?", record, transition
        end
      end
    end

    def effective_current_state
      effective_state = current_state.gsub(/_retry_.*\z/, '')
      current_state.match?(/\A.*_retry_/) ? effective_state : current_state
    end

    def states
      self.class.states
    end

    private

    def logger
      Rails.logger
    end
  end

  module ClassMethods
    def call_if_defined(method_name, record, transition = nil)
      state_machine = record.state_machine
      return true unless state_machine.respond_to?(method_name)

      arity = state_machine.method(method_name).arity
      args = []
      args.push(record) if arity >= 1
      args.push(transition) if (arity == 2) && transition
      state_machine.send(method_name, *args)
    end

    def plan(options = {})
      raise ArgumentError, 'no block provided' unless block_given?

      self.states_cache = {}

      yield

      modified_options = options.symbolize_keys
      end_state        = modified_options.fetch :to, END_STATES
      start_state      = modified_options.fetch :from, START_STATE

      instance_eval do
        state_names = [start_state, *states_cache.keys, end_state]

        state_names.each_with_index do |_state, index|
          current_state = state_names[index]
          next_state    = state_names[index + 1]
          break if next_state.nil?

          add_transitions current_state, next_state
        end
      end
    end

    def step(*names)
      options     = []
      state_names = names.clone
      options     = names.last.respond_to?(:keys) ? state_names.pop : {}
      state_names.each { |state| self.states_cache = states_cache.merge(state => options) }

      state_names.each do |name|
        instance_eval do
          state name
        end
      end
    end

    private

    def add_callbacks_and_guards(*state_names)
      # after_transition(to: state) do |record, transition|
      #   call_if_defined "after_#{state}", record, transition
      # end
      filtered_state_names = state_names.flatten.map(&:to_s) - PREDEFINED_STATES

      filtered_state_names.each do |state_name|
        before_transition(to: state_name) do |record, transition|
          call_if_defined "before_#{state_name}", record, transition
        end

        guard_transition(to: state_name) do |record|
          call_if_defined "can_transition_to_#{state_name}?", record
        end
      end
    end

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

  # rubocop:enable Lint/NestedMethodDefinition, Metrics/AbcSize, Metrics/MethodLength
end
