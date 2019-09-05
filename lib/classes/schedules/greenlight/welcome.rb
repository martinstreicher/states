# frozen_string_literal: true

module Schedules
  module Greenlight
    class Welcome < Base
      self.frequency = :yearly

      memoize def next_occurrence
        Montrose
          .every(:year, on: { enrolled_at.month => enrolled_at.day })
          .starting(time)
          .first
          .beginning_of_day
      end
    end
  end
end
