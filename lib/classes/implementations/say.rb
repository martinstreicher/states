# frozen_string_literal: true

module Implementations
  class Say < Base
    def perform
    end

    private

    def sms
      participant
        .channels
        .sms
        .by_priority
        .first
        .phone_number
    end
  end
end
