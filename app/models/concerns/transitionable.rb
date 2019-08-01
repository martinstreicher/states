module Transitionable
  extend ActiveSupport::Concern
  include Memery
  include Statesman::Adapters::ActiveRecordQueries

  included do
    has_many :transitions, as: :transitionable

    delegate(
      :allowed_transitions,
      :can_transition_to?,
      :current_state,
      :states,
      :transition_to!,
      :transition_to,
      to: :state_machine
    )

    def self.initial_state
      :pending
    end

    def self.transition_class
      Transition
    end

    private_class_method :initial_state
  end

  memoize def state_machine
    klass = "#{self.class.name}StateMachine".constantize

    klass.new(
      self,
      association_name: :transitions,
      transition_class: Transition
    )
  end
end
