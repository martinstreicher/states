# frozen_string_literal: true

module Schedules
  class Base
    include Memery

    SEMAPHORE = Mutex.new

    delegate_missing_to :schedule

    def self.due?(scheduleable, time: nil)
      new(scheduleable, time: time).due?
    end

    def self.frequency
      SEMAPHORE.synchronize do
        @frequency_type
      end
    end

    def self.frequency=(type)
      klass = type.to_s.classify.safe_constantize
      raise(ArgumentError, "#{type} is not a valid schedule") unless klass

      SEMAPHORE.synchronize do
        @frequency_type = klass
      end
    end

    def initialize(scheduleable, time: nil)
      @scheduleable = scheduleable
      @time         = time
    end

    def due?
      return false if occurred?
      return false if now < next_occurrence

      record! now
      true
    end

    def frequency
      self.class.frequency
    end

    memoize def next_occurrence
      time + Schedule::FAR_FUTURE
    end

    memoize def schedule
      frequency
        .where(name: self.class.name, scheduleable: scheduleable)
        .first_or_create!
    end

    private

    def now
      Time.zone.now
    end

    def time
      @time || now
    end

    attr_reader :scheduleable
  end
end
