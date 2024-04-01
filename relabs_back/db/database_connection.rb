require 'pg'

class DatabaseConnection
  def self.new
    PG.connect(
      host: 'database',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
  end
end