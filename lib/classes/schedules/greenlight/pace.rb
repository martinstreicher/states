# frozen_string_literal: true

module Schedules
  module Greenlight
    class Pace < Base
      self.frequency = :hourly

      memoize def next_occurrence
        start_time = analyzer.first_sunday.beginning_of_day
        end_time   = (start_time + 104.weeks).end_of_day

        times =
          calendarize(start_time: start_time, end_time: end_time) do |calendar|
            calendar.add_recurrence_rule IceCube::Rule.hourly(1) # .hour_of_day([*10..17])
          end

        times.next_occurrence(time)
      end
    end
  end
end
