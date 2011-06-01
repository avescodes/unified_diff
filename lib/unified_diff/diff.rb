require 'time'
module UnifiedDiff
  class Diff
    attr_reader :original, :old_file, :old_timestamp, :new_file, :new_timestamp, :chunks

    FILE_PATTERN = /(.*)\t'{2}?(.*)'{2}?/
      OLD_FILE_PATTERN = /--- #{FILE_PATTERN}/
      NEW_FILE_PATTERN = /\+\+\+ #{FILE_PATTERN}/
      CHUNK_PATTERN = /@@ -(\d+),(\d+) \+(\d+),(\d+) @@/
      ADDED_PATTERN = /\+(.*)/
      REMOVED_PATTERN = /-(.*)/
      UNCHANGED_PATTERN = / (.*)/

      TIMESTAMP_FORMAT = 

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
          @old_file, @old_timestamp = $1, Time.parse($2)
        when NEW_FILE_PATTERN
          @new_file, @new_timestamp = $1, Time.parse($2)
        when CHUNK_PATTERN
          @working_chunk = Chunk.new(:old => ($1.to_i..$2.to_i), :new => ($3.to_i..$4.to_i))
          @chunks << @working_chunk
        when ADDED_PATTERN
          @working_chunk.insert_addition($1)
        when REMOVED_PATTERN
          @working_chunk.insert_removal($1)
        when UNCHANGED_PATTERN
          @working_chunk.insert_unchanged($1)
        else
          raise "Unknown Line Type for Line: #{line}"
        end
      end
    end

  end
end
