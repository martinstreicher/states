# frozen_string_literal: true

module Schedules
  module Greenlight
    class Base < Schedules::Base
      SEMAPHORE = Mutex.new

      delegate :enrolled_at, to: :scheduleable
    end
  end
end
