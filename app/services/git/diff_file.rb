module Git
  # File from a parsed GitDiff, consisting of a name and lines.
  #
  # This class is mutable so that it can be statefully created from a diff
  # parser.
  class DiffFile
    attr_accessor :name

    def initialize(line_factory)
      @line_factory = line_factory
      @lines = []
    end

    def blank?
      @lines.blank?
    end

    def append_unchanged(line)
      @lines << @line_factory.new(text: line, changed: false)
    end

    def append_changed(line)
      @lines << @line_factory.new(text: line, changed: true)
    end

    def each_line(&block)
      @lines.each(&block)
    end
  end
end