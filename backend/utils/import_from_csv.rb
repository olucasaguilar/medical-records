require './app/services/medical_record_service'
require './db/database_helper'

DatabaseHelper.wait_for_database
csv_path = './db/data/data.csv'
csv_file_patients = CSV.read(csv_path, col_sep: ';')[1..-1]
reset_table = true
MedicalRecordService::ImportCSV.import(csv_file_patients, reset_table)
puts 'Medical records import finished'