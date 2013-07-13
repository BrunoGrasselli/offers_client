ENV['RACK_ENV'] = 'test'

require "./config/boot"

Dir["./spec/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
