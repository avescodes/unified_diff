require 'time'
module UnifiedDiff
  class Diff
    attr_reader :original, :original_file, :original_timestamp, :modified_file, :modified_timestamp, :chunks
    class UnifiedDiffException < Exception; end

    FILE_PATTERN =      /([^\t\n]+)(?:\t'{2}?([^']+)'{2}?)?/
    OLD_FILE_PATTERN =  /--- #{FILE_PATTERN}/
    NEW_FILE_PATTERN =  /\+\+\+ #{FILE_PATTERN}/
    # Match assignment is tricky for CHUNK_PATTERN
    # $1 and $3 are static, but $2 and $4 can be nil
    #
    # "In many versions of GNU diff, each range can omit the comma and 
    #  trailing value s, in which case s defaults to 1. Note that the 
    #  only really interesting value is the l line number of the first 
    #  range; all the other values can be computed from the diff." 
    #      -- http://en.wikipedia.org/wiki/Diff#Unified_format
    #
    # Pattern -W,X +Y,Z has $1 = W, $2 = X,   $3 = Y, $4 = Z
    # Pattern -W +Y,Z   has $1 = W, $2 = nil, $3 = Y, $4 = Z
    # Pattern -W +Y     has $1 = W, $2 = nil, $3 = Y, $4 = nil
    # Pattern -W,X +Y   has $1 = W, $2 = X,   $3 = Y, $4 = nil
    CHUNK_PATTERN =     /^@@\s+-(\d+)(?:,(\d+))?\s+\+(\d+)(?:,(\d+))?\s+@@/ 
    ADDED_PATTERN =     /^\+(.*)/
    REMOVED_PATTERN =   /^-(.*)/
    UNCHANGED_PATTERN = /^ (.*)/
    NO_NEWLINE_PATTERN = /^\\(\s+No\s+newline\s+at\s+end\s+of\s+file)$/

    # Create and parse a unified diff
    #
    # @param [String] a string containing a unified diff
    # @return [Diff] the parsed diff
    def initialize(diff)
      @original = diff
      parse
    end

    # Render the diff as it appeared originally
    #
    # @return [String] the original unified diff
    def to_s
      @original
    end

  private

    def parse
      @chunks = []
      @original.each_line do |line|
        case line
        when OLD_FILE_PATTERN
          @original_file = $1
          @original_timestamp = Time.parse($2) if $2
        when NEW_FILE_PATTERN
          @modified_file = $1
          @modified_timestamp = Time.parse($2) if $2
        when CHUNK_PATTERN
          old_begin = $1.to_i
          if $2.nil?
            old_end = old_begin + 1
          else
            old_end = old_begin + $2.to_i
          end
          new_begin = $3.to_i
          if $4.nil?
            new_end = new_begin+1
          else
            new_end = new_begin + $4.to_i
          end
          @working_chunk = Chunk.new(original: (old_begin...old_end), modified: (new_begin...new_end))
          @chunks << @working_chunk
        when ADDED_PATTERN
          @working_chunk.send(:insert_addition, $1)
        when REMOVED_PATTERN
          @working_chunk.send(:insert_removal, $1)
        when UNCHANGED_PATTERN
          @working_chunk.send(:insert_unchanged, $1)
        when NO_NEWLINE_PATTERN
          @working_chunk.send(:insert_no_newline_at_eof, $1)
        else
          raise UnifiedDiffException.new("Unknown Line Type for Line:\n#{line}")
        end
      end
    end

  end
end
