require 'helper'

class TestDiffParser < MiniTest::Unit::TestCase
  def setup
    @parser = DiffParser.new
  end

  def test_setup_method
    assert_equal DiffParser, @parser.class
  end
end
