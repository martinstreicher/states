# frozen_string_literal: true

module Schedules
  module Greenlight
    class Pace < Base
      self.frequency = :hourly

      memoize def next_occurrence
        start  = analyzer.first_sunday
        finish = start + 104.weeks

        Montrose
          .every(:hour, interval: 1)
          .starting(start)
          .until(finish)
          .between(time..far_future)
          .first
      end
    end
  end
end
