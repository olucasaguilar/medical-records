require 'pg'
require './app/models/medical_record'
require './db/database_connection'
require './spec/helpers/database_helper'

RSpec.describe MedicalRecord  do
  describe '.all' do
    before(:each) do
      DatabaseHelper.wait_for_database
      @conn = DatabaseConnection.new
      @conn.exec("CREATE TABLE medical_record (id SERIAL PRIMARY KEY, name VARCHAR(255), condition VARCHAR(255))")
    end

    after(:each) do
      @conn.exec("DROP TABLE IF EXISTS medical_record")
      @conn.close
    end

    context 'returns all medical records if connects to database' do
      it 'and there are instances' do
        @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('John Doe', 'Headache')")
        @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('Jane Smith', 'Fever')")

        medical_records = MedicalRecord.all

        expect(medical_records.length).to eq(2)
        expect(medical_records[0]['name']).to eq('John Doe')
        expect(medical_records[1]['condition']).to eq('Fever')
      end

      it 'and there are no instances' do
        medical_records = MedicalRecord.all

        expect(medical_records.length).to eq(0)
        expect(medical_records).to eq([])
      end
    end

    # erro na conexão
    it 'return empty if cannot connect to database' do
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('John Doe', 'Headache')")
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('Jane Smith', 'Fever')")
      allow(PG).to receive(:connect).and_raise(PG::Error)

      medical_records = MedicalRecord.all

      expect(medical_records.length).to eq(0)
      expect(medical_records).to eq([])
      allow(@conn).to receive(:exec).and_call_original
    end
  end
end
