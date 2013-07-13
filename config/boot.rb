require 'bundler'
require 'json'

ENV['RACK_ENV'] ||= 'development'

Bundler.setup
Bundler.require :default, ENV['RACK_ENV']

class Settings < Settingslogic
  source "./config/application.yml"
  namespace ENV['RACK_ENV']
end

['../app', '../app/models'].each do |dir|
  Dir[File.expand_path("../#{dir}/*.rb", __FILE__)].each { |file| require file }
end
