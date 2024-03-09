module MedicalRecordService
  class ImportCSV
    require 'csv'
    require_relative '../database/database_connection'

    DIACRITICS = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')

    def initialize
      @db_conn = DatabaseConnection.new
    end

    def import(csv_path, reset_table = false)
      @csv_path = csv_path
      drop_table if reset_table && table_exists?
      create_table unless table_exists?
      prepare_dataset
      insert_into_database
    end

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

    def drop_table
      @db_conn.exec('DROP TABLE IF EXISTS medical_record')
      puts 'Table dropped'
    end

    def create_table
      csv_attributes = CSV.read(@csv_path, col_sep: ';')[0]
      @attributes = csv_attributes.map { |attr| serialize_attribute(attr) }
      attribute_definitions = @attributes.map { |attr| "#{attr} VARCHAR" }.join(", ")
    
      create_table_query = <<~SQL 
        CREATE TABLE medical_record (#{attribute_definitions})
      SQL
    
      @db_conn.exec(create_table_query)
      puts 'Table created'
    end
    
    def serialize_attribute(str)
      str
        .unicode_normalize(:nfd)
        .tr(DIACRITICS, '')
        .unicode_normalize(:nfc)
        .gsub(/[^a-zA-Z0-9]/, '_')
    end

    def prepare_dataset
      csv_patients = CSV.read(@csv_path, col_sep: ';')[1..]
    
      @converted_values = csv_patients.map do |patient|
        patient.map { |attr| "\'#{serialize_values(attr)}\'" }.join(',')
      end.join('), (')
      puts 'Dataset prepared'
    end
    
    def serialize_values(str)
      str
        .gsub(/'/, "''")
    end

    def insert_into_database
      @db_conn.exec("INSERT INTO medical_record (#{@attributes.join(', ')}) VALUES (#{@converted_values})")
      puts 'Data inserted'
    end
  end
end
