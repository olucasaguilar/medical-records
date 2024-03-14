require './server.rb'

require 'capybara'
require 'capybara/rspec'
require 'rspec'

def app
  Sinatra::Application
end

Capybara.app = app