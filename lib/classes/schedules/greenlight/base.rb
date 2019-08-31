# frozen_string_literal: true

module Schedules
  module Greenlight
    class Base < Schedules::Base
      delegate :enrolled_at, to: :participant

      def self.due?(participant, time: nil)
        new(participant, time: time).due?
      end

      def initialize(participant, time: nil)
        @participant = participant
        @time        = time || now
      end

      def due?; end

      private

      attr_reader :participant, :time
    end
  end
end
