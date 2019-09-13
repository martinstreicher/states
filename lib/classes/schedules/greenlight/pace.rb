# frozen_string_literal: true

module Schedules
  module Greenlight
    class Pace < Base
      self.frequency = :hourly

      memoize def start
        analyzer.first_sunday.beginning_of_day
      end

      memoize def stop
        (start + 104.weeks).end_of_day
      end

      memoize def times
        calendarize(start_time: start, end_time: stop) do |calendar|
          calendar.add_recurrence_rule IceCube::Rule.hourly(1) # .hour_of_day([*10..17])
        end
      end
    end
  end
end
