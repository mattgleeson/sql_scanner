class SqlScanner
  class InvalidStatement < StandardError; end

  cattr_accessor :checks
  self.checks = []

  def self.check_sql(sql)
    checks.each do |check|
      unless check.call(sql)
        raise InvalidStatement.new(sql)
      end
    end
  end
end
