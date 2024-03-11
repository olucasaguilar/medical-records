require './app/services/medical_record_service'
require './db/database_helper'

DatabaseHelper.wait_for_database
csv_path = './db/data/data.csv'
reset_table = true
MedicalRecordService::ImportCSV.import(csv_path, reset_table)
puts 'Medical records import finished'