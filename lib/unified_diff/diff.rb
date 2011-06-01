require 'time'
module UnifiedDiff
  class Diff
    attr_reader :original, :original_file, :original_timestamp, :modified_file, :modified_timestamp, :chunks
    class UnifiedDiffException < Exception; end

    FILE_PATTERN =      /(.*)\t'{2}?(.*)'{2}?/
    OLD_FILE_PATTERN =  /--- #{FILE_PATTERN}/
    NEW_FILE_PATTERN =  /\+\+\+ #{FILE_PATTERN}/
    CHUNK_PATTERN =     /@@ -(\d+),(\d+) \+(\d+),(\d+) @@/
    ADDED_PATTERN =     /\+(.*)/
    REMOVED_PATTERN =   /-(.*)/
    UNCHANGED_PATTERN = / (.*)/

    def initialize(diff)
      @original = diff
      parse
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
          @working_chunk = Chunk.new(original: ($1.to_i..$2.to_i), modified: ($3.to_i..$4.to_i))
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
