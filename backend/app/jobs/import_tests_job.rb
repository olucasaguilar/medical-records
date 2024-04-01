require 'sidekiq'
require 'csv'
require './app/services/medical_record_service'

class ImportTestsJob
  include Sidekiq::Job

  def perform(csv_file_content)
    MedicalRecordService::ImportCSV.import(csv_file_content)
  end
end