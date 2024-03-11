require 'pg'

class DatabaseConnection
  def self.new
    PG.connect(
      host: 'postgres',
      user: 'postgres',
      dbname: 'postgres',
      password: 'postgres'
    )
  end
end