ENV['RACK_ENV'] = 'test'

require "./config/boot"

Dir["./spec/support/**/*.rb"].each { |file| require file }

require 'capybara'
require 'capybara/dsl'

Capybara.app = OffersClient

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.include WebMock::API
end
