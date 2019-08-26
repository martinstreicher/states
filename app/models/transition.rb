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
    'eleven' => 11,
    'twelve' => 12
  }.freeze

  by_star_field :transition_at

  belongs_to :transitionable, polymorphic: true

  validate :expiry_after_transition_at, if: proc { |r| r.transition_at }

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

  def self.now
    Time.zone.now.utc
  end

  def self.scheduled_to_expire(at: now)
    most_recent.before(at, field: :expire_at)
  end

  def self.scheduled_to_transition(at: now)
    most_recent.before(at, field: :transition_at)
  end

  def self.unexpired
    where.not(to_state: :expire)
  end

  def self.viable
    where.not(to_state: %i[expire finish pending])
  end

  def attempt
    counter = to_state.gsub(/\A.*_/, '')
    WORDS_TO_NUMBERS[counter] || 0
  end

  def effective_state
    to_state.gsub(/_retry_.*\z/, '')
  end

  def retry?
    to_state.match?(/_retry_/)
  end

  private_class_method :now

  private

  def expiry_after_transition_at
    return if expire_at.nil? || transition_at.nil?
    return if expire_at > transition_at

    errors.add(:expire_at, 'expiry occurs before the transition time')
  end

  def update_most_recent
    last_transition = order.order_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end
