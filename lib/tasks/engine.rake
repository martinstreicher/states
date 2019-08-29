# frozen_string_literal: true

namespace :engine do
  desc 'Run the engine to advance each machine'
  
  task run: :environment do
    Engine.new.execute
  end
end
