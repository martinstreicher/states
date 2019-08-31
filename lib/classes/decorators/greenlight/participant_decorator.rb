# frozen_string_literal: true

module Decorators
  module Greenlight
    class ParticipantDecorator < ApplicationDecorator
      delegate_all

def enrolled_at
  created_at
end

      def welcomed
        history[:welcomed]
      end

      def welcomed=(value)
        history[:welcomed] = value
      end
    end
  end
end
