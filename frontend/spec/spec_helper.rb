require './server.rb'

require 'capybara'
require 'rspec'
require 'capybara/rspec'
require "capybara/cuprite"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    browser_options: { 'no-sandbox': nil },
    inspector: true,
    url:  'http://chrome:3333',
    base_url: 'http://server:3000' 
  )
end

Capybara.javascript_driver = :cuprite

include Capybara::DSL