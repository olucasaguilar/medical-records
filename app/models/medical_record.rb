require 'pg'
require_relative '../../db/database_connection'

class MedicalRecord
  def self.all(conn = nil)
    begin
      @conn = conn
      @conn = DatabaseConnection.new if conn.nil?

      query_result = @conn.exec('SELECT * FROM medical_record')
      medical_records = query_result.map do |record|
        Hash[query_result.fields.zip(record.values)]
      end

      @conn.close if conn.nil?
      medical_records
    rescue PG::Error => e
      []
    end
  end
end
