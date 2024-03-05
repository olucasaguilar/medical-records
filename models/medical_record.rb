require 'pg'

class MedicalRecord
  def self.all
    begin
      conn = connect_database
      medical_records = conn.exec('SELECT * FROM medical_record')
      records_array = medical_records.map do |record|
        Hash[medical_records.fields.zip(record.values)]
      end
      conn.close
      records_array
    rescue PG::Error => e
      []
    end
  end

  private

  def self.connect_database
    PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
  end
end
