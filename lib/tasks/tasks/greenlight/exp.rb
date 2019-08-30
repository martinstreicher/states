# frozen_string_literal: true

module Tasks
  module Greenlight
    class Exp < Tasks::Base
      def initialize
        namespace :greenlight do
          task exp: :environment do
            Participant.all
          end
        end
      end
    end
  end
end
