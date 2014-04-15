module Git
  # Solution with files parsed from a Git diff.
  class Solution < SimpleDelegator
    def initialize(solution, parser_factory)
      super(solution)
      @parser_factory = parser_factory
    end

    def files
      parser_factory.new(diff: diff).parse
    end

    private

    attr_reader :parser_factory
  end
end
