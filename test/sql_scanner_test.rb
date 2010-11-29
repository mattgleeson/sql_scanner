require 'test_helper'

class SqlScannerTest < ActiveSupport::TestCase
  def setup
    @conn = ActiveRecord::Base.connection
    SqlScanner.checks.clear
  end

  def test_no_config_no_foul
    assert_nothing_raised do
      @conn.select_value("SELECT NOW() FROM DUAL")
    end
  end

  def test_ok_on_good_answer
    SqlScanner.checks.push lambda {|s| true }
    assert_nothing_raised do
      @conn.select_value("SELECT NOW() FROM DUAL")
    end
  end

  def test_dies_on_bad_answer
    SqlScanner.checks.push lambda {|s| false }
    assert_raise SqlScanner::InvalidStatement do
      @conn.select_value("SELECT NOW() FROM DUAL")
    end
  end

  def test_statement_is_passed_in
    stmt = "SELECT NOW() FROM DUAL /* ABC123 */"
    got_stmt = ''
    SqlScanner.checks.push lambda {|s| got_stmt = s; true }
    @conn.select_value(stmt)
    assert_equal stmt, got_stmt
  end
end
