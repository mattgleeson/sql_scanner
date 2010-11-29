require 'sql_scanner'
class ActiveRecord::ConnectionAdapters::AbstractAdapter
  def log_with_sql_scanner(*args, &block)
    SqlScanner.check_sql(args.first)
    log_without_sql_scanner(*args, &block)
  end
  alias_method_chain :log, :sql_scanner
end
