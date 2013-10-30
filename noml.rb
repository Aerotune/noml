class Noml
  class << self
    @@preceding_whitespaces = /^(\s+)(?=\S)/
    
    def parse_file path
      parse File.read(path)
    end
    
    def parse noml
      parse_lines noml.lines
    end
    
    def parse_lines lines
      lines  = lines.reject { |line| line.strip == "" }
      return nil if lines.empty?
      indent = indent_of lines.first
      
      indent_line_indexes = indent_line_indexes indent, lines
      groups_ranges       = groups_ranges indent_line_indexes

      results = []
      groups_ranges.each do |range| 
        new_lines = lines[range]
        if new_lines.length == 1
          results << new_lines[0].strip
        else
          result = parse_lines(new_lines[1..-1])
          result = result.first if result.length == 1 if result.kind_of? Array
          results << {new_lines[0].strip => result}
        end
      end
      
      if results.length == 1
        results.first
      else
        results
      end
    end
    
    def indent_of line
      match = line.match(@@preceding_whitespaces)
      match ? match.end(0) : 0
    end
    
    def indent_line_indexes indent, lines
      line_indexes = []
      lines.each_with_index do |line, line_index|
        line_indent = indent_of line
        line_indexes << line_index if line_indent == indent
      end
      line_indexes << lines.length
    end
    
    def groups_ranges indent_line_indexes
      ranges = []
      (indent_line_indexes.length - 1).times do |i|
        min = indent_line_indexes[i]
        max = indent_line_indexes[i+1]
        ranges << (min...max)
      end
      ranges
    end    
  end
end