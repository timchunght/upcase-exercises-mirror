module Git
  # Parses diffs produced by `git diff` into files.
  class DiffParser
    # Raises when unrecognized lines are encountered in diffs.
    class ParseError < StandardError
    end

    pattr_initialize :diff, :file_factory

    def parse
      @files = []
      diff.each_line do |line|
        process line
      end
      @files.reject(&:blank?)
    end

    private

    def process(line)
      case line
      when /^diff/
        start_file
      when /^\+\+\+ b\/(.*)/
        set_filename $1
      when /^(?: |\+)(.*)/
        add_line $1
      when /^deleted file mode/
        delete_file
      when /^(index|-|@@|new file mode|old mode|new mode)/
        # Ignore
      else
        parse_error(line)
      end
    end

    def start_file
      @current_file = file_factory.new
      @files << @current_file
    end

    def delete_file
      @files.pop
    end

    def set_filename(name)
      current_file.name = name
    end

    def add_line(line)
      current_file.puts line
    end

    def current_file
      @current_file || raise(ParseError, 'No file to modify')
    end

    def parse_error(line)
      raise ParseError, "Couldn't parse line: #{line.inspect}"
    end
  end
end
