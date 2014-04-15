module Git
  # File from a parsed GitDiff, consisting of a name and lines.
  #
  # This class is mutable so that it can be statefully created from a diff
  # parser.
  class DiffFile
    attr_accessor :name

    def initialize
      @buffer = StringIO.new
    end

    def blank?
      @buffer.length == 0
    end

    def puts(line)
      @buffer.puts(line)
    end

    def each_line(&block)
      @buffer.rewind
      @buffer.each_line(&block)
    end
  end
end
