module Transitionable
  extend ActiveSupport::Concern
  include Statesman::Adapters::ActiveRecordQueries

  included do
    has_many :transitions, as: :transitionable

    delegate(
      :allowed_transitions,
      :can_transition_to?,
      :current_state,
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

  def state_machine
    klass = "#{self.class.name}StateMachine".constantize

    @state_machine ||=
      klass.new(
        self,
        association_name: :transitions,
        transition_class: Transition
      )
  end

  def expired(_transition); end
  def finished(_transition); end
  def start(_transition); end
end
