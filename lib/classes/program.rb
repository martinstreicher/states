# frozen_string_literal: true

require 'active_record/validations'

class Program
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
    subclass.extend ActiveModel::Validations
    subclass.extend Internals::Callbacks
    subclass.extend Internals::Transitions
    subclass.extend Internals::Validations
    subclass.extend Instructions::Plan
    subclass.extend Instructions::Say
    subclass.extend Instructions::Step

    subclass.instance_eval do
      class_attribute :states_cache, instance_writer: false, default: {}

      PREDEFINED_STATES.each { |state_name| state state_name }
      state :pending, initial: true
      transition from: :pending, to: START_STATE
      transition from: START_STATE, to: END_STATES

      PREDEFINED_STATES.each do |state_name|
        after_transition(to: state_name, after_commit: true) do |record, transition|
          call_if_defined "after_#{state_name}", record, transition
        end

        before_transition(to: state_name) do |record, transition|
          call_if_defined "before_#{state_name}", record, transition
          call_if_defined state_name, record, transition
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
  # rubocop:enable Lint/NestedMethodDefinition, Metrics/AbcSize, Metrics/MethodLength
end
