ENV['RACK_ENV'] = 'test'

require './config/environment'
require './application'

if %w(1 true).include? ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

module ApplicationMixin
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include ApplicationMixin

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end