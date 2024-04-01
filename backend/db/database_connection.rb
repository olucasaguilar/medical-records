require 'pg'

class DatabaseConnection
  def self.new
    PG.connect(
      host: 'database',
      dbname: self.environment,
      user: 'postgres',
      password: 'postgres'
    )
  end

  private

  def self.environment
    return 'test' if ENV['RACK_ENV'] == 'test'
    'development'
  end
end