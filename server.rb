require 'pg'
require 'sinatra'
require 'rack/handler/puma'

conn = PG.connect(
  host: 'postgres',
  user: 'postgres',
  dbname: 'postgres',
  password: 'postgres'
)

get '/tests' do
  content_type :json
  medical_records = conn.exec('SELECT * FROM medical_record')
  
  records_array = medical_records.map do |record|
    Hash[medical_records.fields.zip(record.values)]
  end
  
  records_array.to_json
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)