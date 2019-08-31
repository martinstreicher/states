# frozen_string_literal: true

module Tasks
  module Greenlight
    class Exp < Tasks::Base
      def initialize
        namespace :greenlight do
          task :exp, [:participant] => :environment do |_task, args|
            participant = find_participant args[:participant]
            ppo(participant)
            # each_participant do |p|
            #   puts p.name
            # end
          end
        end
      end

      def ppo(record)
        puts record.name
      end
    end
  end
end
