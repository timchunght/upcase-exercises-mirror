require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'webmock/rspec'
require 'dependencies/testing'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Features, type: :feature
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.infer_base_class_for_anonymous_controllers = true
  config.order = 'random'
  config.use_transactional_fixtures = false

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.include Dependencies::Testing
end

Capybara.javascript_driver = :webkit
WebMock.disable_net_connect!(allow_localhost: true)
