require 'time'
module UnifiedDiff
  class Diff
    attr_reader :original, :original_file, :original_timestamp, :modified_file, :modified_timestamp, :chunks
    class UnifiedDiffException < Exception; end

    FILE_PATTERN =      /(.*)\t'{2}?(.*)'{2}?/
    OLD_FILE_PATTERN =  /--- #{FILE_PATTERN}/
    NEW_FILE_PATTERN =  /\+\+\+ #{FILE_PATTERN}/
    # Match assignment is tricky for CHUNK_PATTERN
    # $1,$2 are static, but $3,$4,$5 vary
    # if pattern is X,Y then $3 = X,Y, $4 = X, $5 = Y
    # if pattern is X   then $3 = X
    CHUNK_PATTERN =     /@@ -(\d+),(\d+) \+((\d+),(\d+)|(\d+)) @@/ 
    ADDED_PATTERN =     /\+(.*)/
    REMOVED_PATTERN =   /-(.*)/
    UNCHANGED_PATTERN = / (.*)/

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
          @original_file, @original_timestamp = $1, Time.parse($2)
        when NEW_FILE_PATTERN
          @modified_file, @modified_timestamp = $1, Time.parse($2)
        when CHUNK_PATTERN
          old_begin = $1.to_i
          old_end = old_begin + $2.to_i
          if $3.include?(',') # Will match if non-edge case encountered
            new_begin = $4.to_i
            new_end = new_begin + $5.to_i
          else
            new_begin = $3.to_i
            new_end = new_begin + 1
          end
          @working_chunk = Chunk.new(original: (old_begin...old_end), modified: (new_begin...new_end))
          @chunks << @working_chunk
        when ADDED_PATTERN
          @working_chunk.send(:insert_addition, $1)
        when REMOVED_PATTERN
          @working_chunk.send(:insert_removal, $1)
        when UNCHANGED_PATTERN
          @working_chunk.send(:insert_unchanged, $1)
        else
          raise UnifiedDiffException.new("Unknown Line Type for Line:\n#{line}")
        end
      end
    end

  end
end
