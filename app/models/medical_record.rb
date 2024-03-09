require 'pg'

class MedicalRecord
  def self.all(conn = nil)
    begin
      @conn = conn
      open_connection

      query_result = @conn.exec('SELECT * FROM medical_record')
      medical_records = query_result.map do |record|
        Hash[query_result.fields.zip(record.values)]
      end

      close_connection
      medical_records
    rescue PG::Error => e
      []
    end
  end

  private

  def self.open_connection
    if ENV['RACK_ENV'] != 'test'
      @conn = PG.connect(
        host: 'postgres',
        user: 'postgres',
        dbname: 'postgres',
        password: 'postgres'
      )
    end
  end

  def self.close_connection
    @conn.close if ENV['RACK_ENV'] != 'test'
  end
end
