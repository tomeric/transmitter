# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)

require 'rspec/rails'
require 'ffaker'
require 'factory_girl'
require 'remarkable/mongoid'
require 'database_cleaner'

# Requires factories in ./factories/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each {|f| require f}

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.orm      = :mongoid
    DatabaseCleaner.strategy = :truncation
  end
  
  config.before(:each) do
    DatabaseCleaner.clean
  end
  
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end
