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
    @conn.exec('DROP TABLE medical_record') if table_already_exists

    converted_attributes = prepare_attributes

    @conn.exec("CREATE TABLE medical_record (#{converted_attributes.map { |attr| "#{attr} VARCHAR" }.join(', ')})")
    puts 'Prepared table'
  end

  def prepare_dataset
    csv = CSV.read(CSV_PATH, col_sep: ';')
    csv_attributes = csv[0]
    csv_patients = csv[1..]

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

  def table_already_exists
    table_existence = @conn.exec('SELECT EXISTS (SELECT FROM pg_tables WHERE tablename = \'medical_record\')')
    table_existence[0]['exists'] == 't'
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
