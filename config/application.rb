# frozen_string_literal: true

require_relative 'boot'
require 'active_support/time'
require 'humanize'
require 'rails/all'
require 'sidekiq/api'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module States
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.load_defaults 5.2
  end
end

loader = Zeitwerk::Loader.new
loader.tag = 'Zeitwerk'
loader.push_dir(Rails.root.join('lib', 'classes'))
loader.push_dir(Rails.root.join('lib', 'tasks'))
loader.log! # Enable as needed; can be noisy
loader.setup
