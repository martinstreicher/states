# frozen_string_literal: true

module Schedules
  module Greenlight
    class Welcome < Base
      self.frequency = :yearly

      memoize def next_occurrence
        enrolled_at_datetime = Chronic.parse(enrolled_at.to_s)

        Montrose
          .every(:year, on: { enrolled_at_datetime.month => enrolled_at_datetime.day })
          .starting(now)
          .first
          .beginning_of_day
      end
    end
  end
end
