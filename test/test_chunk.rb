require 'helper'

class TestChunk < MiniTest::Unit::TestCase
  def setup
    @chunk = UnifiedDiff::Chunk.new(old: (1..2), new: (1..3))
  end

  def test_ranges_accessible
    assert_equal (1..2), @chunk.old_range
    assert_equal (1..3), @chunk.new_range
  end

  def test_raw_lines_accessible_in_order
    @chunk.insert_unchanged("foo")
    @chunk.insert_addition( "bar")
    @chunk.insert_removal(  "baz")
    assert_equal [" foo","+bar","-baz"], @chunk.raw_lines
  end

  def test_old_lines
    @chunk.insert_unchanged("foo")
    @chunk.insert_removal("bar")
    @chunk.insert_addition("baz")
    assert_equal %w{foo bar}, @chunk.old_lines
  end

  def test_new_lines
    @chunk.insert_unchanged("foo")
    @chunk.insert_removal("bar")
    @chunk.insert_addition("baz")
    assert_equal %w{foo baz}, @chunk.new_lines
  end
end
