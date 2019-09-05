# frozen_string_literal: true

module Schedules
  module Greenlight
    class Base < Schedules::Base
      SEMAPHORE = Mutex.new

      memoize def analyzer
        RecursiveOpenStruct.new first_sunday: (enrolled_at.sunday - 1.week)
      end

      memoize def enrolled_at
        Chronic.parse(scheduleable.enrolled_at.to_s)
      end
    end
  end
end
