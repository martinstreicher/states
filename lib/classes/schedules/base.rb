# frozen_string_literal: true

module Schedules
  class Base
    include Memery

    def now
      Time.zone.now.beginning_of_day
    end
  end
end
