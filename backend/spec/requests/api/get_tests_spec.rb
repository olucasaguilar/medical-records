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
      data_1 = { 'nome_paciente' => 'João', 'cpf' => '111.111.111-11',  'token_resultado_exame' => 'AAA' }
      data_2 = { 'nome_paciente' => 'Pedro', 'cpf' => '222.222.222-22',  'token_resultado_exame' => 'BBB' }
      data_3 = { 'nome_paciente' => 'Vitor', 'cpf' => '333.333.333-33',  'token_resultado_exame' => 'CCC' }
      mr1 = MedicalRecord.new(data_1)
      mr2 = MedicalRecord.new(data_2)
      mr3 = MedicalRecord.new(data_3)
      fake_return = [mr1, mr2, mr3]
      allow(MedicalRecord).to receive(:all).and_return(fake_return)

      get '/tests'
      
      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to include('application/json')
      records = JSON.parse(last_response.body)
      expect(records.count).to eq(3)
      expect(records[0]['cpf']).to eq('111.111.111-11')
      expect(records[1]['cpf']).to eq('222.222.222-22')
      expect(records[2]['cpf']).to eq('333.333.333-33')
      expect(records[0]['nome_paciente']).to eq('João')
      expect(records[1]['nome_paciente']).to eq('Pedro')
      expect(records[2]['nome_paciente']).to eq('Vitor')
      expect(records[0]['token_resultado_exame']).to eq('AAA')
      expect(records[1]['token_resultado_exame']).to eq('BBB')
      expect(records[2]['token_resultado_exame']).to eq('CCC')
    end
  end

  context 'searching by token' do
    it 'successfully' do
      data_1 = { 'nome_paciente' => 'João', 'cpf' => '111.111.111-11',  'token_resultado_exame' => 'AAA' }
      fake_return = MedicalRecord.new(data_1)
      allow(MedicalRecord).to receive(:find).with('BBB').and_return(fake_return)

      get '/tests/search?token=BBB'
      
      expect(last_response.status).to eq(200)
      expect(last_response.headers['Content-Type']).to include('application/json')
      record = JSON.parse(last_response.body)
      expect(record['cpf']).to eq('111.111.111-11')
      expect(record['nome_paciente']).to eq('João')
      expect(record['token_resultado_exame']).to eq('AAA')
    end
  end
end
