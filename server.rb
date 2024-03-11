require 'sinatra'
require_relative 'app/models/medical_record.rb'

get '/tests' do
  content_type :json
  records = MedicalRecord.all
  records.to_json
end
