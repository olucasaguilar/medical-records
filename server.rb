require 'sinatra'
require 'rack/handler/puma'
require_relative 'models/medical_record.rb'

get '/tests' do
  content_type :json
  records = MedicalRecord.all
  records.to_json
end

if ENV['RACK_ENV'] != 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end