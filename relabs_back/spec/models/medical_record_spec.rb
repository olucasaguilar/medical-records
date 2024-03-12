require 'pg'
require './app/models/medical_record'
require './app/services/medical_record_service'
require './db/database_connection'
require './db/database_helper'

RSpec.describe MedicalRecord  do
  describe '.all' do
    before(:each) do
      DatabaseHelper.wait_for_database
      @conn = DatabaseConnection.new
      MedicalRecordService::CreateTable.create(@conn)
    end

    after(:each) do
      MedicalRecordService::DropTable.drop(@conn)
      @conn.close
    end

    context 'returns all medical records if connects to database' do
      it 'and there are instances' do
        data_1 = { 'nome_paciente' => 'João', 'token_resultado_exame' => 'AA1' }
        data_2 = { 'nome_paciente' => 'Pedro', 'token_resultado_exame' => 'BB2' }
        mr1 = MedicalRecord.new(data_1)
        mr2 = MedicalRecord.new(data_2)
        MedicalRecord.insert_into_database(@conn, [mr1, mr2])

        medical_records = MedicalRecord.all

        expect(medical_records.length).to eq(2)
        expect(medical_records[0].nome_paciente).to eq('João')
        expect(medical_records[1].nome_paciente).to eq('Pedro')
      end

      it 'and there are no instances' do
        medical_records = MedicalRecord.all

        expect(medical_records.length).to eq(0)
        expect(medical_records).to eq([])
      end
    end

    # erro na conexão
    it 'return empty if cannot connect to database' do
      data_1 = { 'nome_paciente' => 'João', 'token_resultado_exame' => 'AA1' }
      MedicalRecord.insert_into_database(@conn, [MedicalRecord.new(data_1)])
      allow(PG).to receive(:connect).and_raise(PG::Error)

      medical_records = MedicalRecord.all

      expect(medical_records.length).to eq(0)
      expect(medical_records).to eq([])
      allow(@conn).to receive(:exec).and_call_original
    end
  end
end
