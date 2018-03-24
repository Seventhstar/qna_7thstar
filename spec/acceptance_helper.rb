require 'rails_helper'

RSpec.configure do |config|
  if RUBY_PLATFORM == "x64-mingw32"
    Capybara.javascript_driver = :selenium_chrome
    # Capybara.register_driver :selenium do |app| 
    #   profile = Selenium::WebDriver::Firefox::Profile.new 
    #   Capybara::Selenium::Driver.new( app, :browser => :firefox, :profile => profile ) 
    # end
  else
    Capybara.javascript_driver = :webkit
  end
  Capybara.server = :puma

  config.include AcceptanceHelper, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
