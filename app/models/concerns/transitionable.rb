# frozen_string_literal: true

module Transitionable
  extend ActiveSupport::Concern
  include Memery
  include Statesman::Adapters::ActiveRecordQueries

  included do
    has_many :transitions, as: :transitionable, dependent: :destroy

    delegate(
      :allowed_transitions,
      :can_transition_to?,
      :current_state,
      :effective_current_state,
      :states,
      :transition_to!,
      :transition_to,
      to: :state_machine
    )

    def self.due(at: Time.zone.now.utc)
      joined.merge(transition_class.viable.due(at: at))
    end

    def self.expired
      joined.merge(transition_class.expired)
    end

    def self.joined
      joins(:transitions)
    end

    def self.major
      joined.merge(transition_class.major)
    end

    def self.minor
      joined.merge(transition_class.minor)
    end

    def self.most_recent
      joined(transitions_class.viable.most_recent)
    end

    def self.scheduled_to_expire(at: Time.zone.now.utc)
      joined.merge(transition_class.most_recent.after(at, field: :expire_at))
    end

    def self.unexpired
      joined.merge(transitions_class.unexpired)
    end

    def self.viable
      joined.merge(transition_class.viable)
    end

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
