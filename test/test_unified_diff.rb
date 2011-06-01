require 'helper'

class TestUnifiedDiff < MiniTest::Unit::TestCase
  def setup
    diff = <<-DIFF.unindent
      --- original.txt	2011-05-31 11:14:13.000000000 -0500
      +++ modified.txt	2011-05-31 11:14:44.000000000 -0500
      @@ -1,5 +1,5 @@
       foo
       bar
      -baz
      +Baz
       qux
       quux
    DIFF
    @diff = UnifiedDiff.parse(diff)
  end

  def test_setup_method_does_something
    assert_equal UnifiedDiff::Diff, @diff.class
  end

  def test_parses_original_information
    assert_equal "original.txt", @diff.original_file
    assert_equal Time.parse('2011-05-31 11:14:13.000000000 -0500'), @diff.original_timestamp
  end

  def test_parses_modified_filename
    assert_equal "modified.txt", @diff.modified_file
    assert_equal Time.parse('2011-05-31 11:14:44.000000000 -0500'), @diff.modified_timestamp
  end

  def test_parses_chunk_header
    @chunk = @diff.chunks.first
    assert_equal (1..5), @chunk.original_range
    assert_equal (1..5), @chunk.modified_range
  end

  def test_parses_unchanged_line
    skip "not performing line-type logic yet"
  end

  def test_parses_removed_lines
    skip "not performing line-type logic yet"
    @chunk = @diff.chunks.first
    #assert_equal [3, 'baz'], @chunk.removed.first
  end

  def test_parses_added_lines
    skip "not performing line-type logic yet"
    @chunk = @diff.chunks.first
    #assert_equal [3, 'Baz'], @chunk.added.first
  end

  def test_raises_on_invalid_line
    diff = <<-DIFF.unindent
      --- original.txt	2011-05-31 11:14:13.000000000 -0500
      +++ modified.txt	2011-05-31 11:14:44.000000000 -0500
      @@ -1,1 +1,1 @@
      &foo
    DIFF
    assert_raises(UnifiedDiff::Diff::UnifiedDiffException) { UnifiedDiff.parse(diff) }
  end

  def test_parses_multiple_chunks
    diff = <<-DIFF.unindent
      --- original.txt	2011-05-31 11:14:13.000000000 -0500
      +++ modified.txt	2011-05-31 11:14:44.000000000 -0500
      @@ -1,1 +1,1 @@
       -foo
       +bar
      @@ -4,4 +4,4 @@
       -foo
       +bar
    DIFF
    @diff = UnifiedDiff.parse(diff)
    assert_equal 2, @diff.chunks.length
  end
end
