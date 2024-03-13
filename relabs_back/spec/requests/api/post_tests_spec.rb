require './server'
require './app/services/medical_record_service'
require 'rack/test'

RSpec.describe 'POST /tests' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'successfully' do
    it 'imports tests from csv upload' do
      tests_service_importer_spy = spy(MedicalRecordService::ImportCSV)
      stub_const('MedicalRecordService::ImportCSV', tests_service_importer_spy)
      allow(tests_service_importer_spy).to receive(:import)
      file_path = 'spec/support/data.csv'
      csv_file = Rack::Test::UploadedFile.new(file_path, 'text/csv')

      post('/tests', csv_file: csv_file)
      
      expect(last_response.status).to eq(201)
      expect(last_response.headers['Content-Type']).to include('application/json')
      response = JSON.parse(last_response.body)
      expect(response['message']).to eq('Importação realizada com sucesso!')
      expect(tests_service_importer_spy).to have_received(:import)
    end
  end
end