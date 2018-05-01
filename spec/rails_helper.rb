# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'devise'
require 'factory_bot_rails'
require 'database_cleaner'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include ApiHelper, type: :controller
  config.include ActiveJob::TestHelper, perform_enqueued: true

  config.before(:each, perform_enqueued: true) do
    clear_enqueued_jobs
  end
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
  end

  config.before do
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
