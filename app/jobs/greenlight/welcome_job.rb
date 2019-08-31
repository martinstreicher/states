# frozen_string_literal: true

module Greenlight
  class WelcomeJob < Base
    queue_as :default

    def perform_on_participant(participant)
      return if participant.welcomed
      return unless Schedules::Greenlight::Welcome.due?(participant)

      participant.welcomed = true
      participant.save!

      # do work
    end
  end
end
