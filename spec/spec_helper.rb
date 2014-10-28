require 'capybara'
require "capybara-webkit"
require 'database_cleaner'

RSpec.configure do |config|
  
  Capybara.javascript_driver = :webkit
end