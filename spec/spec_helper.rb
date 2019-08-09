# frozen_string_literal: true

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'byebug'
require 'factory_bot'
require 'faker'
require 'rspec/its'
require 'timecop'
require 'shoulda-matchers'
require 'test_prof/recipes/rspec/let_it_be'

begin
  spec_dir        = File.dirname(__FILE__)
  config_files    = File.join(spec_dir, 'initializers/**/*.rb')
  shared_contexts = File.join(spec_dir, 'shared_contexts/**/*.rb')
  shared_examples = File.join(spec_dir, 'shared_examples/**/*.rb')
  support_files   = File.join(spec_dir, 'support/**/*.rb')

  dirs = [
    config_files,
    shared_contexts,
    shared_examples,
    support_files
  ]

  dirs.each { |dir| Dir[dir].each { |f| require f } }
end
