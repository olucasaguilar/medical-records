ENV['RACK_ENV'] = 'test'

require 'pg'
require 'rack/test'
require 'csv'
require '../app/services/medical_record_service.rb'
require '../app/models/medical_record.rb'
require '../db/database_connection'
require './helpers/database_helper'

RSpec.describe MedicalRecordService::ImportCSV  do
  before(:each) do
    DatabaseHelper.wait_for_database
    @conn = DatabaseConnection.new
  end

  after(:each) do
    @conn.exec("DROP TABLE IF EXISTS medical_record")
    @conn.close
  end

  describe '.import' do
    context 'successfully imports medical records from CSV to database' do
      it 'and the table does not exist yet' do
        csv_path = 'support/data.csv'
        csv_lines = CSV.read(csv_path, col_sep: ';')[1..-1].length

        MedicalRecordService::ImportCSV.import(csv_path)

        expect(MedicalRecord.all.length).to eq(csv_lines)
      end

      it 'and the table already exists' do
        @conn.exec("CREATE TABLE medical_record (cpf VARCHAR, nome_paciente VARCHAR)")
        csv_path = 'support/data.csv'
        csv_lines = CSV.read(csv_path, col_sep: ';')[1..-1].length

        MedicalRecordService::ImportCSV.import(csv_path)

        expect(MedicalRecord.all.length).to eq(csv_lines)
      end

      it 'reseting the table' do
        @conn.exec("CREATE TABLE medical_record (cpf VARCHAR, nome_paciente VARCHAR)")
        @conn.exec("INSERT INTO medical_record (cpf, nome_paciente) VALUES ('12345678901', 'First Person')")  
        @conn.exec("INSERT INTO medical_record (cpf, nome_paciente) VALUES ('32165498701', 'Second Person')")
        csv_path = 'support/data.csv'

        reset_table = true
        MedicalRecordService::ImportCSV.import(csv_path, reset_table)

        medical_records_names = MedicalRecord.all_names
        expect(medical_records_names.length).not_to eq(5)
        expect(medical_records_names.length).to eq(3)
        expect(medical_records_names).to_not include('First Person', 'Second Person')
      end

      it 'not reseting the table' do
        @conn.exec("CREATE TABLE medical_record (cpf VARCHAR, nome_paciente VARCHAR)")
        @conn.exec("INSERT INTO medical_record (cpf, nome_paciente) VALUES ('12345678901', 'First Person')")  
        @conn.exec("INSERT INTO medical_record (cpf, nome_paciente) VALUES ('32165498701', 'Second Person')")
        csv_path = 'support/data.csv'

        reset_table = false
        MedicalRecordService::ImportCSV.import(csv_path, reset_table)

        medical_records_names = MedicalRecord.all_names
        expect(medical_records_names.length).to eq(5)
        expect(medical_records_names.length).not_to eq(3)
        expect(medical_records_names).to include('First Person', 'Second Person')
      end
    end
  end
end
