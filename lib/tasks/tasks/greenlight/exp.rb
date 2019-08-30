# frozen_string_literal: true

module Tasks
  module Greenlight
    class Exp < Tasks::Base
      def initialize
        namespace :greenlight do
          task exp: :environment do
            each_participant do |p|
              puts p.name
            end 
          end
        end
      end
    end
  end
end
