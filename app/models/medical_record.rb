require 'pg'
require_relative '../../db/database_connection'

class MedicalRecord
  def self.all
    begin
      @conn = DatabaseConnection.new

      query_result = @conn.exec('SELECT * FROM medical_record')
      medical_records = query_result.map do |record|
        Hash[query_result.fields.zip(record.values)]
      end

      @conn.close
      medical_records
    rescue PG::Error => e
      []
    end
  end

  def self.all_names
    all.map { |mr| mr['nome_paciente'] }
  end
end
