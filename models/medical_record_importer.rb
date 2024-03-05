require 'pg'
require 'csv'

class MedicalRecordImporter
  DIACRITICS = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')
  CSV_PATH = '../data/data.csv'

  def initialize; end

  def import
    connect_database
    prepare_table
    prepare_dataset
    puts 'Data imported successfully'
  end

  private

  def connect_database
    @conn = PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
    puts 'Connected to database'
  end

  def prepare_table
    @conn.exec('DROP TABLE IF EXISTS medical_record')

    converted_attributes = prepare_attributes
    attribute_definitions = converted_attributes.map { |attr| "#{attr} VARCHAR" }.join(",\n  ")

    create_table_query = <<~SQL 
      CREATE TABLE medical_record (#{attribute_definitions})
    SQL

    @conn.exec(create_table_query)
    puts 'Prepared table'
  end

  def prepare_dataset
    csv_patients = CSV.read(CSV_PATH, col_sep: ';')[1..]

    converted_values = csv_patients.map do |patient|
      patient.map { |attr| "\'#{serialize_values(attr)}\'" }.join(',')
    end.join('), (')

    @conn.exec("INSERT INTO medical_record (#{@attributes.join(', ')}) VALUES (#{converted_values})")
    puts 'Prepared database'
  end

  def prepare_attributes
    csv_attributes = CSV.read(CSV_PATH, col_sep: ';')[0]
    @attributes = csv_attributes.map { |attr| serialize_attribute(attr) }
  end

  def serialize_attribute(str)
    str
      .unicode_normalize(:nfd)
      .tr(DIACRITICS, '')
      .unicode_normalize(:nfc)
      .gsub(/[^a-zA-Z0-9]/, '_')
  end

  def serialize_values(str)
    str
      .gsub(/'/, "''")
  end
end
