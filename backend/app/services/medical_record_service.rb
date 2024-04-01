module MedicalRecordService
  class ImportCSV
    require 'csv'
    require './app/models/medical_record'
    require_relative '../../db/database_connection'

    def self.import(csv_file_patients, reset_table = false)
      @db_conn = DatabaseConnection.new

      MedicalRecordService::DropTable.drop(@db_conn) if reset_table && table_exists?
      MedicalRecordService::CreateTable.create(@db_conn) unless table_exists?
      insert_records_into_database(csv_file_patients)

      @db_conn.close
    end

    class << self
      private

      def table_exists?
        query = <<~SQL
          SELECT EXISTS (
            SELECT 1
            FROM pg_tables
            WHERE schemaname = 'public'
            AND tablename = 'medical_record'
          )
        SQL

        query_return = @db_conn.exec(query)
        query_return[0]['exists'] == 't'
      end

      def insert_records_into_database(csv_file_patients)
        medical_records = csv_file_patients.map do |patient|
          patient = patient.map { |attr| "#{@db_conn.escape(attr)}" }
          data = Hash[MedicalRecord.attributes.zip(patient)]
          MedicalRecord.new(data)
        end

        MedicalRecord.insert_into_database(@db_conn, medical_records)
      end
    end
  end

  class CreateTable
    def self.create(conn)
      attribute_definitions = MedicalRecord.attributes.map { |attr| "#{attr} VARCHAR" }.join(", ")
      
      create_table_query = <<~SQL 
        CREATE TABLE medical_record (#{attribute_definitions})
      SQL
    
      conn.exec(create_table_query)
    end
  end

  class DropTable
    def self.drop(conn)
      conn.exec("DROP TABLE IF EXISTS medical_record")
    end
  end
end
