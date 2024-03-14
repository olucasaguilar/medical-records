require 'sinatra'
require './app/models/medical_record'
require './app/services/medical_record_service'

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  records = MedicalRecord.all
  records.to_json
end

get '/tests/search' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  token = params['token']
  record = MedicalRecord.find(token)
  record.to_json
end

post '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
  
  if params['csv_file'].nil?
    return status 400; { message: 'Falha ao realizar a importação!' }.to_json
  end

  MedicalRecordService::ImportCSV.import(params['csv_file']['tempfile'])
  status 201; { message: 'Importação realizada com sucesso!' }.to_json
end
