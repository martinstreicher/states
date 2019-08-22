# frozen_string_literal: true

require_relative 'boot'
require 'humanize'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module States
  class Application < Rails::Application
    config.load_defaults 5.2
  end
end

loader = Zeitwerk::Loader.new
loader.log!
loader.tag = 'Zeitwerk'
loader.push_dir(Rails.root.join('lib', 'classes'))
loader.setup
