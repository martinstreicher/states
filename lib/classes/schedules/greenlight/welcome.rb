# frozen_string_literal: true

module Schedules
  module Greenlight
    class Welcome < Base
      def due?
        time >= schedule
      end

      memoize def schedule
        Montrose
          .every(:year, on: { enrolled_at.month => enrolled_at.day })
          .starting(now)
          .first
          .beginning_of_day
      end
    end
  end
end
