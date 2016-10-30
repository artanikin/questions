require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  config.include AcceptenceHelper, type: :feature

  Capybara.server_host = '0.0.0.0'
  Capybara.server_port = 3001
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 5
  Capybara.ignore_hidden_elements = true
  Capybara.save_path = './tmp/capybara_output'

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }

  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { DatabaseCleaner.clean }
end
