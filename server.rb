require 'pg'
require 'sinatra'
require 'rack/handler/puma'

def connect_database
  PG.connect(
    host: 'postgres',
    user: 'postgres',
    dbname: 'postgres',
    password: 'postgres'
  )
end

get '/tests' do
  content_type :json
  begin
    conn = connect_database
    medical_records = conn.exec('SELECT * FROM medical_record')
    
    records_array = medical_records.map do |record|
      Hash[medical_records.fields.zip(record.values)]
    end
    
    records_array.to_json
  rescue PG::Error => e
    status 500
    { error: 'Erro ao conectar ao banco de dados' }.to_json
  ensure
    conn.close if conn
  end
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)