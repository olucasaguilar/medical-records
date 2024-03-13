require 'sinatra'
require './app/models/medical_record'
require './app/services/medical_record_service'

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  records = MedicalRecord.all
  records.to_json
end

post '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  
  MedicalRecordService::ImportCSV.import(params['csv_file']['tempfile'])
  
  status 201
  { message: 'Importação realizada com sucesso!' }.to_json
end
