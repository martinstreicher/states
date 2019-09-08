# frozen_string_literal: true

class Schedule < ApplicationRecord
  SPAN = 100.years.freeze

  def datetimes
    return enum_for(:datetimes) unless block_given?

    history.each { |datetime| yield datetime }
  end

  def distant_past
    now - SPAN
  end

  def far_future
    now + SPAN
  end

  def most_recent_occurrence
    history.last || distant_past
  end

  def occurred?
    now < (most_recent_occurrence + self.class::SPAN)
  end

  def record!(datetime = now)
    (self.history ||= []).tap do |log|
      log << datetime
      save!
    end
  end

  def wipe!(number_of_events: nil, past: :distant)
    if number_of_events.nil?
      erased_events = history.clone
      self.history = []
      save!
      return erased_events
    end

    operation = past == :distant ? :shift : :pop
    history.send(operation, number_of_events).tap { |_erased_events| save! }
  end

  private

  memoize def now
    Time.zone.now
  end
end
