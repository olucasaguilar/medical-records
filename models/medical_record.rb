require 'pg'

class MedicalRecord
  def self.all
    begin
      conn = connection_database
      query_result = conn.exec('SELECT * FROM medical_record')
      medical_records = query_result.map do |record|
        Hash[query_result.fields.zip(record.values)]
      end
      conn.close
      medical_records
    rescue PG::Error => e
      []
    end
  end

  private

  def self.connection_database
    PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
  end
end
