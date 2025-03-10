# frozen_string_literal: true

require 'simplecov'
if ENV.fetch('CI', nil) == 'true'
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  SimpleCov.coverage_dir('tmp/simple_cov') # must match codecov-action directory option
end
SimpleCov.start do
  add_filter(%r{\A/spec/})
end

require 'bundler/setup'
Bundler.require(:default, :test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.mock_with(:rspec) do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.filter_run_when_matching(:focus)
end
