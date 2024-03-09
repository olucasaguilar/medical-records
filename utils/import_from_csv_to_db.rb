require_relative '../services/medical_record_service'

csv_path = '../data/data.csv'
MedicalRecordService::ImportCSV.new.import(csv_path, reset_table = true)