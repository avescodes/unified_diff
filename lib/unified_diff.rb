module UnifiedDiff
  def self.parse(diff)
    UnifiedDiff::Diff.new(diff)
  end
 end

require 'unified_diff/diff'
require 'unified_diff/chunk'
