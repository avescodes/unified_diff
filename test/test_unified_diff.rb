require 'helper'

class TestUnifiedDiff < MiniTest::Unit::TestCase
  def setup
    @parser = UnifiedDiff.new
  end

  def test_setup_method
    assert_equal UnifiedDiff, @parser.class
  end

  def test_parses_original_filename

  end

  def test_parses_new_filename

  end

  def test_parses_chunk_header

  end
  def test_parses_unchanged_line

  end
  def test_parses_removed_lines

  end
  def test_parses_added_lines

  end
end
