# frozen_string_literal: true

module Greenlight
  class Base < ApplicationJob
    queue_as :default

    def decorator_class
      Decorators::Greenlight::ParticipantDecorator
    end

    def perform(*args)
      identifier    = args[0]
      participant   = Participant.find_by(id: identifier)
      participant ||= Participant.find_by(uuid: identifier)
      return unless participant

      perform_on_participant decorator_class.decorate(participant)
    end

    def perform_on_participant(_participant)
      raise UnimplementedMethodError, __method__
    end
  end
end
