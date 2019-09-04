# frozen_string_literal: true

class Schedule < ApplicationRecord
  FAR_FUTURE = 100.years.freeze

  def datetimes
    return enum_for(:datetimes) unless block_given?

    history.each { |datetime| yield datetime }
  end

  def most_recent_occurrence
    history.last || (now + FAR_FUTURE)
  end

  def now
    Time.zone.now
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

  def hour(datetime = most_recent_occurrence)
    datetime.strftime('%D %H')
  end

  def minute(datetime = most_recent_occurrence)
    datetime.strftime('%D %T')
  end

  def month(datetime = most_recent_occurrence)
    datetime.strftime('%m/%Y')
  end

  def week(datetime = most_recent_occurrence)
    datetime.strftime('%U')
  end

  def year(datetime = most_recent_occurrence)
    datetime.strftime('%-m %-d')
  end

  def years
    convert :year
  end
end
