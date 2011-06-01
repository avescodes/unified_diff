module UnifiedDiff
  class Chunk
    attr_reader :old_range,:new_range,:raw_lines
    def initialize(ranges)
      @old_range = ranges[:old]
      @new_range = ranges[:new]
      @raw_lines = []
    end

    def insert_addition(line)
      @raw_lines << "+#{line}"
    end

    def insert_removal(line)
      @raw_lines << "-#{line}"
    end

    def insert_unchanged(line)
      @raw_lines << " #{line}"
    end

    def new_lines
      @raw_lines.select {|line| line[0] == ' ' || line[0] == '+' }.map {|line| line[1..-1] }
    end

    def old_lines
      @raw_lines.select {|line| line[0] == ' ' || line[0] == '-' }.map {|line| line[1..-1] }
    end
  end
end
