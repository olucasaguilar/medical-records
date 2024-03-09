require 'pg'

class DatabaseConnection
  def initialize
    @conn = PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
    puts 'Connected to database'
  end

  def exec(query)
    @conn.exec(query)
  end
end