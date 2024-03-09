require 'pg'

class DatabaseConnection
  def initialize
    @conn = PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
  end

  def exec(query)
    @conn.exec(query)
  end

  def close
    @conn.close
  end
end