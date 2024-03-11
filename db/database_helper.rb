class DatabaseHelper
  def self.wait_for_database
    max_attempts = 30
    attempts = 0
    while attempts < max_attempts
      begin
        DatabaseConnection.new.close
        break
      rescue PG::ConnectionBad
        attempts += 1
        sleep 1
      end
    end
    raise 'Database not ready' if attempts == max_attempts
  end
end
