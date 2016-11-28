require 'rails_helper'
require 'rspec/page-regression'
require 'capybara/poltergeist'
require 'rack_session_access/capybara'
require 'capybara/email/rspec'
require 'puma'

RSpec.configure do |config|
  include ActionView::RecordIdentifier
  config.include AcceptenceHelper, type: :feature
  config.include OmniauthMacros, type: :feature

  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3001
  Capybara.default_max_wait_time = 2
  Capybara.ignore_hidden_elements = true
  Capybara.save_path = './tmp/capybara_output'
  Capybara.always_include_port = true

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      timeout: 90, js_errors: true,
      phantomjs_logger: Logger.new(STDOUT),
      window_size: [1020, 740]
    )
  end

  Capybara.javascript_driver = :poltergeist

  Capybara.server = :puma

  OmniAuth.config.test_mode = true

  RSpec::PageRegression.configure do |c|
    c.threshold = 0.01
  end

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { Timecop.return }

  config.append_after(:each) do
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end
end
