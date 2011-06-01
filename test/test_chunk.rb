require 'helper'

class TestChunk < MiniTest::Unit::TestCase
  def setup
    @chunk = UnifiedDiff::Chunk.new(original: (1..2), modified: (1..3))
  end

  def test_ranges_accessible
    assert_equal (1..2), @chunk.original_range
    assert_equal (1..3), @chunk.modified_range
  end

  def test_raw_lines_accessible_in_order
    @chunk.send(:insert_unchanged,"foo")
    @chunk.send(:insert_addition, "bar")
    @chunk.send(:insert_removal,  "baz")
    assert_equal [" foo","+bar","-baz"], @chunk.raw_lines
  end

  def test_original_lines
    @chunk.send(:insert_unchanged,"foo")
    @chunk.send(:insert_removal,"bar")
    @chunk.send(:insert_addition,"baz")
    assert_equal %w{foo bar}, @chunk.original_lines
  end

  def test_modified_lines
    @chunk.send(:insert_unchanged,"foo")
    @chunk.send(:insert_removal,"bar")
    @chunk.send(:insert_addition,"baz")
    assert_equal %w{foo baz}, @chunk.modified_lines
  end

  def test_removed_lines
    @chunk.send(:insert_removal,'foo')
    @chunk.send(:insert_unchanged, 'bar')
    assert_equal ['foo'], @chunk.removed_lines
  end

  def test_added_lines
    @chunk.send(:insert_addition,'foo')
    @chunk.send(:insert_unchanged, 'bar')
    assert_equal ['foo'], @chunk.added_lines
  end
end
