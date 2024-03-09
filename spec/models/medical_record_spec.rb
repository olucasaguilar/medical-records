ENV['RACK_ENV'] = 'test'

require 'pg'
require 'rack/test'
require '../app/models/medical_record.rb'

RSpec.describe MedicalRecord  do
  describe '.all' do
    before(:each) do
      @conn = PG.connect(
        dbname: 'test_db',
        user: 'postgres',
        password: 'postgres',
        host: 'test_postgres'
      )

      @conn.exec("CREATE TABLE medical_record (id SERIAL PRIMARY KEY, name VARCHAR(255), condition VARCHAR(255))")
    end

    after(:each) do
      @conn.exec("DROP TABLE IF EXISTS medical_record")
      @conn.close if @conn
    end

    it 'returns all medical records' do
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('John Doe', 'Headache')")
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('Jane Smith', 'Fever')")

      medical_records = MedicalRecord.all(@conn)

      expect(medical_records.length).to eq(2)
      expect(medical_records[0]['name']).to eq('John Doe')
      expect(medical_records[1]['condition']).to eq('Fever')
    end

    it 'returns there are no medical records' do
      medical_records = MedicalRecord.all(@conn)

      expect(medical_records.length).to eq(0)
      expect(medical_records).to eq([])
    end

    # erro na conexão
    it 'return empty if cannot connect to database' do
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('John Doe', 'Headache')")
      @conn.exec("INSERT INTO medical_record (name, condition) VALUES ('Jane Smith', 'Fever')")
      allow(@conn).to receive(:exec).and_raise(PG::Error)

      medical_records = MedicalRecord.all(@conn)

      expect(medical_records.length).to eq(0)
      expect(medical_records).to eq([])
      allow(@conn).to receive(:exec).and_call_original
    end
  end
end
