# frozen_string_literal: true

module Transitionable
  extend ActiveSupport::Concern
  include Memery
  include Statesman::Adapters::ActiveRecordQueries

  included do # rubocop:disable Metrics/BlockLength
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

    delegate :successors, to: :state_machine_class

    def self.due(at: now)
      joined.merge(transition_class.viable.due(at: at))
    end

    def self.expired
      joined.merge(transition_class.expired)
    end

    def self.initial_state
      :pending
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

    def self.now
      Time.zone.now.utc
    end

    def self.scheduled_to_expire(at: now)
      joined.merge(transition_class.most_recent.before(at, field: :expire_at))
    end

    def self.scheduled_to_transition(at: now)
      joined.merge(transition_class.most_recent.before(at, field: :transition_at))
    end

    def self.transition_class
      Transition
    end

    def self.unexpired
      joined.merge(transitions_class.unexpired)
    end

    def self.viable
      joined.merge(transition_class.viable)
    end

    private_class_method :initial_state
    private_class_method :now
  end

  memoize def state_machine
    script_name = ((defined?(name) && name.presence) || self.class.name).classify

    "#{script_name}Program"
      .constantize
      .new(
        self,
        association_name: :transitions,
        transition_class: Transition
      )
  end

  def state_machine_class
    state_machine.class
  end
end
