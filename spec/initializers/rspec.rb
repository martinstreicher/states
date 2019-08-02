# frozen_string_literal: true

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

RSpec.configure do |config|
  Kernel.srand config.seed

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.filter_run_when_matching :focus

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.profile_examples = 10

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true
end
