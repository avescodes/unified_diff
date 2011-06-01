module UnifiedDiff
  class Chunk
    attr_reader :original_range,:modified_range,:raw_lines

    # Create a new chunk with the specified modified and original ranges
    #
    # @param [Hash] A hash with keys for original and modified line range
    # @return [Array] the lines in the modified version of the chunk
    def initialize(ranges)
      @original_range = ranges[:original]
      @modified_range = ranges[:modified]
      @raw_lines = []
    end


    # Render the chunk as it appeared in the original unified diff
    #
    # @return [String] the chunk as it appeared in the original unified diff
    def to_s
      "@@ "+
        "-#{@original_range.begin},#{@original_range.count} " +
        "+#{@modified_range.begin},#{@modified_range.count} " +
      "@@\n" +
      @raw_lines.join("\n") +
      "\n"
    end

    # Return an array of lines that were removed from the original version of the chunk
    #
    # @return [Array] the lines that were removed from the original
    def removed_lines
      processed_lines_of_types('-')
    end

    # Return an array of lines that were added to the original version of the chunk
    #
    # @return [Array] the lines that were added to the original
    def added_lines
      processed_lines_of_types('+')
    end

    # Return an array of lines that are present in the modified version of the chunk
    #
    # @return [Array] the lines in the modified version of the chunk
    def modified_lines
      processed_lines_of_types(' ','+')
    end

    # Return an array of lines that are present in the original version of the chunk
    #
    # @return [Array] the lines in the original version of the chunk
    def original_lines
      processed_lines_of_types(' ','-')
    end

  private
    def processed_lines_of_types(*types)
      @raw_lines.select {|line| types.include?(line[0])}.map {|line| line[1..-1]}
    end

   # Insert a new addition line into the list of lines for this chunk
    #
    # @param [String] the line to be inserted (without '+' tag)
    # @return [Array] the new list of raw lines
    def insert_addition(line)
      @raw_lines << "+#{line}"
    end

    # Insert a new removal line into the list of lines for this chunk
    #
    # @param [String] the line to be inserted (without '-' tag)
    # @return [Array] the new list of raw lines
    def insert_removal(line)
      @raw_lines << "-#{line}"
    end

    # Insert a new unchanged line into the list of lines for this chunk
    #
    # @param [String] the line to be inserted (without ' ' tag)
    # @return [Array] the new list of raw lines
    def insert_unchanged(line)
      @raw_lines << " #{line}"
    end

  end
end
