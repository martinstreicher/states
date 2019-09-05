# frozen_string_literal: true

module Schedules
  module Greenlight
    class AdvanceGoals < Base
      self.frequency = :weekly

      memoize def next_occurrence
        start  = analyzer.first_sunday
        finish = start + 104.weeks

        Montrose
          .every(:week, interval: 8)
          .starting(start)
          .until(finish)
          .between(time..far_future)
          .at('5 am')
          .first
          .beginning_of_day
      end
    end
  end
end
