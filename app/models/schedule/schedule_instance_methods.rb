# frozen_string_literal: true

class Schedule < ApplicationRecord
  FAR_FUTURE = 100.years.freeze

  def datetimes
    return enum_for(:datetimes) unless block_given?

    history.each { |datetime| yield datetime }
  end

  def far_future
    now + FAR_FUTURE
  end

  def most_recent_occurrence
    history.last || far_future
  end

  def occurred?
    false
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

  def annum(datetime = most_recent_occurrence)
    datetime.strftime('%Y')
  end

  def convert(format)
    raise ArgumentError, "#{format} is invalid" unless respond_to?(format, _private = true)

    history.map { |datetime| send format, datetime }
  end

  def day(datetime = most_recent_occurrence)
    datetime.strftime('%D')
  end

  def days
    convert :day
  end

  def hour(datetime = most_recent_occurrence)
    datetime.strftime('%D %H')
  end

  def hours
    convert :hour
  end

  def minute(datetime = most_recent_occurrence)
    datetime.strftime('%D %T')
  end

  def minutes
    convert :minute
  end

  def month(datetime = most_recent_occurrence)
    datetime.strftime('%m/%Y')
  end

  def months
    convert :month
  end

  def now
    Time.zone.now
  end

  def week(datetime = most_recent_occurrence)
    datetime.strftime('%U')
  end

  def weeks
    convert :week
  end

  def year(datetime = most_recent_occurrence)
    datetime.strftime('%-m %-d')
  end

  def years
    convert :year
  end
end
