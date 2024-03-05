require 'pg'
require 'csv'

conn = PG.connect(
  host: 'postgres',
  user: 'postgres',
  dbname: 'postgres',
  password: 'postgres'
)

puts 'Connected to database'

DIACRITICS = [*0x1DC0..0x1DFF, *0x0300..0x036F, *0xFE20..0xFE2F].pack('U*')
def convert_attribute(str)
  str
    .unicode_normalize(:nfd)
    .tr(DIACRITICS, '')
    .unicode_normalize(:nfc)
    .gsub(/[^a-zA-Z0-9]/, '_')
end

def convert_values(str)
  str
    .gsub(/'/, "''")
end

csv = CSV.read('../data/data.csv', col_sep: ';')
csv_attributes = csv[0]
csv_patients = csv[1..]
converted_attributes = []
csv_attributes.each { |attr| converted_attributes << convert_attribute(attr) }

puts 'Prepared attributes'

result = conn.exec('SELECT EXISTS (SELECT FROM pg_tables WHERE tablename = \'medical_record\')')
conn.exec('DROP TABLE medical_record') if result[0]['exists'] == 't'

conn.exec("CREATE TABLE medical_record (#{converted_attributes.map { |attr| "#{attr} VARCHAR" }.join(', ')})")

puts 'Prepared table'

puts 'Preparing database'

csv_patients.each do |patient|
  conn.exec("INSERT INTO medical_record (#{converted_attributes.join(', ')}) VALUES (#{patient.map { |attr| "\'#{convert_values(attr)}\'" }.join(', ')})")
end

puts 'Prepared database'
