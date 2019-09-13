# frozen_string_literal: true

module Schedules
  class Base
    include Memery

    SEMAPHORE = Mutex.new
    SPAN      = 100.years.freeze

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
      return false unless next_occurrence
      return false if now < next_occurrence

      record! now
      true
    end

    def frequency
      self.class.frequency
    end

    memoize def next_occurrence
      return unless (start..stop).cover?(time)

      times.next_occurrence(time)
    end

    memoize def schedule
      frequency
        .where(name: self.class.name, scheduleable: scheduleable)
        .first_or_create!
    end

    def start
      time - SPAN
    end

    memoize def stop
      time + SPAN
    end

    memoize def times
      calendarize do |calendar|
        calendar.add_recurrence_rule IceCube::Rule.yearly(time + SPAN)
      end
    end

    private

    def calendarize(start_time: start, end_time: stop, &_block)
      IceCube::Schedule.new(start_time, end_time: end_time) do |calendar|
        yield calendar
      end
    end

    def now
      Time.zone.now
    end

    memoize def time
      @time || now
    end

    attr_reader :scheduleable
  end
end
