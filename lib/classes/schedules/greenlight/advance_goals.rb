# frozen_string_literal: true

module Schedules
  module Greenlight
    class AdvanceGoals < Base
      memoize def schedule
      #
# Advance the goals each eight weeks
# daily(
#   frequency:              8.weeks,
#   hour_of_day:            5,
#   ignore_preferred_days:  true,
#   ignore_preferred_times: true,
#   name:                   :greenlight_goal_change_schedule,
#   start:                  analyzer.first_sunday,
#   stop:                   analyzer.first_sunday + 104.weeks
# ) do
#   Studies::Greenlight::GoalChanger.advance participant: participant
# end
        start  = analyzer.first_sunday
        finish = start + 104.weeks

        Montrose
          .every(:week, interval: 8),
          .between(start..finish)
          .at('5 am')
          .first
          .beginning_of_day
      end
    end
  end
end
