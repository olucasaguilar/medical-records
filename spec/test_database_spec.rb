require 'pg'
require 'rack/test'

RSpec.describe 'Database' do
  include Rack::Test::Methods

  describe 'Table Creation' do
    before(:all) do
      @conn = PG.connect(
        dbname: 'test_db',
        user: 'postgres',
        password: 'postgres',
        host: 'test_postgres'
      )

      @conn.exec("CREATE TABLE test_table (id SERIAL PRIMARY KEY, name VARCHAR(255), age INT)")
    end

    after(:all) do
      @conn.exec("DROP TABLE IF EXISTS test_table")
      @conn.close if @conn
    end

    it 'creates a table successfully' do
      expect(table_exists?('test_table')).to be(true)
    end
  end

  def table_exists?(table_name)
    result = @conn.exec("SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '#{table_name}')")
    result.getvalue(0, 0) == 't'
  end
end
