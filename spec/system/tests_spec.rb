ENV['RACK_ENV'] = 'test'

require_relative '../../server.rb'
require 'rack/test'

RSpec.describe 'App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    context 'successfully' do
      it 'there are no records' do
        get '/tests'
        
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include('application/json')
        records = JSON.parse(last_response.body)
        expect(records).to eq([])
      end

      it 'there are records' do
        fake_return = [
          {
            cpf: "048.973.170-88",
            nome_paciente: "Emilly Batista Neto",
            email_paciente: "gerald.crona@ebert-quigley.com",
            data_nascimento_paciente: "2001-03-11",
            endereco_rua_paciente: "165 Rua Rafaela",
            cidade_paciente: "Ituverava",
            estado_patiente: "Alagoas",
            crm_medico: "B000BJ20J4",
            crm_medico_estado: "PI",
            nome_medico: "Maria Luiza Pires",
            email_medico: "denna@wisozk.biz",
            token_resultado_exame: "IQCZ17",
            data_exame: "2021-08-05",
            tipo_exame: "hemácias",
            limites_tipo_exame: "45-52",
            resultado_tipo_exame: "97"
          }
        ]
        allow(MedicalRecord).to receive(:all).and_return(fake_return)

        get '/tests'
        
        expect(last_response.status).to eq(200)
        expect(last_response.headers['Content-Type']).to include('application/json')
        records = JSON.parse(last_response.body)
        expect(records.count).to eq(1)
        expect(records.first['cpf']).to eq('048.973.170-88')
      end
    end
  end
end
