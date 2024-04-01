require 'spec_helper'
require 'pg'
require 'csv'
require './app/services/medical_record_service'
require './app/models/medical_record'
require './db/database_connection'
require './db/database_helper'

RSpec.describe MedicalRecordService::ImportCSV  do
  before(:each) do
    DatabaseHelper.wait_for_database
    @conn = DatabaseConnection.new
  end

  after(:each) do
    MedicalRecordService::DropTable.drop(@conn)
    @conn.close
  end

  describe '.import' do
    context 'successfully imports medical records from CSV to database' do
      it 'and the table does not exist yet' do
        csv_path = 'spec/support/data.csv'
        csv_file_patients = CSV.read(csv_path, col_sep: ';')[1..-1]
        csv_lines = csv_file_patients.length

        MedicalRecordService::ImportCSV.import(csv_file_patients)

        expect(MedicalRecord.all.length).to eq(csv_lines)
      end

      it 'and the table already exists' do
        MedicalRecordService::CreateTable.create(@conn)
        csv_path = 'spec/support/data.csv'
        csv_file_patients = CSV.read(csv_path, col_sep: ';')[1..-1]
        csv_lines = csv_file_patients.length

        MedicalRecordService::ImportCSV.import(csv_file_patients)

        expect(MedicalRecord.all.length).to eq(csv_lines)
      end

      it 'reseting the table' do
        MedicalRecordService::CreateTable.create(@conn)
        data_1 = { 'nome_paciente' => 'First Person', 'token_resultado_exame' => 'AA1' }
        data_2 = { 'nome_paciente' => 'Second Person', 'token_resultado_exame' => 'BB2' }
        mr1 = MedicalRecord.new(data_1)
        mr2 = MedicalRecord.new(data_2)
        MedicalRecord.insert_into_database(@conn, [mr1, mr2])
        csv_path = 'spec/support/data.csv'
        csv_file_patients = CSV.read(csv_path, col_sep: ';')[1..-1]

        reset_table = true
        MedicalRecordService::ImportCSV.import(csv_file_patients, reset_table)

        medical_records_names = MedicalRecord.all_names
        expect(medical_records_names.length).not_to eq(5)
        expect(medical_records_names.length).to eq(3)
        expect(medical_records_names).to_not include('First Person', 'Second Person')
      end

      it 'not reseting the table' do
        MedicalRecordService::CreateTable.create(@conn)
        data_1 = { 'nome_paciente' => 'First Person', 'token_resultado_exame' => 'AA1' }
        data_2 = { 'nome_paciente' => 'Second Person', 'token_resultado_exame' => 'BB2' }
        mr1 = MedicalRecord.new(data_1)
        mr2 = MedicalRecord.new(data_2)
        MedicalRecord.insert_into_database(@conn, [mr1, mr2])
        csv_path = 'spec/support/data.csv'
        csv_file_patients = CSV.read(csv_path, col_sep: ';')[1..-1]

        reset_table = false
        MedicalRecordService::ImportCSV.import(csv_file_patients, reset_table)

        medical_records_names = MedicalRecord.all_names
        expect(medical_records_names.length).to eq(5)
        expect(medical_records_names.length).not_to eq(3)
        expect(medical_records_names).to include('First Person', 'Second Person')
      end
    end
  end
end
