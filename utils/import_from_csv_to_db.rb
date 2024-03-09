require_relative '../app/services/medical_record_service'

csv_path = '../db/data/data.csv'
MedicalRecordService::ImportCSV.import(csv_path, reset_table = true)
puts 'Medical records import finished'