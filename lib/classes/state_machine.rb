# frozen_string_literal: true

class StateMachine
  include Statesman::Machine
  include Statesman::Events

  def initialize
    super nil, association_name: :transitions, transition_class: Transition
  end

  # rubocop:disable Lint/NestedMethodDefinition, Metrics/AbcSize, Metrics/MethodLength

  def self.inherited(subclass)
    subclass.extend ClassMethods

    subclass.instance_eval do
      class_attribute :states_cache, instance_writer: false, default: {}

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
        record.expire(transition) if record.respond_to?(:expire)
      end
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
      end_state        = modified_options.fetch :to, %i[expire finish]
      start_state      = modified_options.fetch :from, :start

      instance_eval do
        state_names = states_cache.keys
        transition from: start_state, to: state_names.first
        transition from: state_names.last, to: end_state

        state_names.each_with_index do |_state, index|
          current_state = state_names[index]
          next_state    = state_names[index + 1]
          break if next_state.nil?

          add_transitions current_state, next_state
        end
      end
    end

    def step(*names)
      state_names = names.flat_map do |name|
        modified_state    = name.clone
        modified_state    = { name => [] } unless modified_state.respond_to?(:keys)
        self.states_cache = states_cache.merge modified_state
        modified_state.keys
      end

      state_names.each do |name|
        instance_eval do
          state name, minor: false
        end
      end
    end

    private

    def add_transitions(current_state, next_state)
      add_minor_transitions current_state, next_state
      add_major_transitions current_state, next_state
    end

    def add_major_transitions(current_state, next_state)
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

    def add_minor_transitions(current_state, next_state)
    end
  end

  # rubocop:enable Lint/NestedMethodDefinition, Metrics/AbcSize, Metrics/MethodLength
end
