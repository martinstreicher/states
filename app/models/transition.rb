# frozen_string_literal: true

class Transition < ApplicationRecord
  WORDS_TO_NUMBERS = {
    'one'    => 1,
    'two'    => 2,
    'three'  => 3,
    'four'   => 4,
    'five'   => 5,
    'six'    => 6,
    'seven'  => 7,
    'eight'  => 8,
    'nine'   => 9,
    'ten'    => 10,
    'eleven' => 11
  }.freeze

  by_star_field :transition_at

  belongs_to :transitionable, polymorphic: true

  validates :expire_at,     absence: true, if: proc { |r| r.transition_at }
  validates :transition_at, absence: true, if: proc { |r| r.expire_at }

  # TODO: Revisit whether this is needed
  # after_destroy :update_most_recent, if: :most_recent?

  def self.due(at: Time.zone.now.utc)
    viable.most_recent.before(at)
  end

  def self.expired
    where to_state: :expire
  end

  def self.major
    where minor: false
  end

  def self.minor
    where minor: true
  end

  def self.most_recent
    viable.where(most_recent: true)
  end

  def self.scheduled_to_expire(at: Time.zone.now.utc)
    most_recent.after(at, field: :expire_at)
  end

  def self.unexpired
    where.not(to_state: :expire)
  end

  def self.viable
    where.not(to_state: %i[expire finish pending])
  end

  def attempt
    counter = to_state.gsub(/\A.*_/, '')
    WORDS_TO_NUMBERS[counter]
  end

  def effective_state
    to_state.gsub(/_retry_.*\z/, '')
  end

  def retry?
    to_state.match?(/_retry_/)
  end

  private

  def update_most_recent
    last_transition = order.order_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end
