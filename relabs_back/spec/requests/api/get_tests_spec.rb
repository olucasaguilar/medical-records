require './server'
require 'rack/test'

RSpec.describe 'GET /tests' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'successfully' do
    it 'and there are no records' do
      allow(MedicalRecord).to receive(:all).and_return([])

      get '/tests'
      
      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to include('application/json')
      records = JSON.parse(last_response.body)
      expect(records).to eq([])
    end

    it 'and there are records' do
      fake_return = [
        {
          cpf: "048.973.170-88",
          nome_paciente: "Emilly Batista Neto"
        }
      ]
      allow(MedicalRecord).to receive(:all).and_return(fake_return)

      get '/tests'
      
      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to include('application/json')
      records = JSON.parse(last_response.body)
      expect(records.count).to eq(1)
      expect(records.first['cpf']).to eq('048.973.170-88')
      expect(records.first['nome_paciente']).to eq('Emilly Batista Neto')
    end
  end
end
