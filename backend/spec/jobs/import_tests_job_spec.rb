require './app/jobs/import_tests_job'
require 'sidekiq/testing'

RSpec.describe ImportTestsJob do
  describe '.perform' do
    it 'call MedicalRecordService import with the csv file content' do
      tests_service_importer_spy = spy(MedicalRecordService::ImportCSV)
      stub_const('MedicalRecordService::ImportCSV', tests_service_importer_spy)
      allow(tests_service_importer_spy).to receive(:import)
      file_path = 'spec/support/data.csv'
      csv_file_patients = CSV.read(file_path, col_sep: ';')[1..-1]

      ImportTestsJob.new.perform(csv_file_patients)
      
      expect(tests_service_importer_spy).to have_received(:import)
    end
  end
end