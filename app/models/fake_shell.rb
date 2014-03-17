class FakeShell
  attr_reader :commands

  def initialize
    @commands = []
  end

  def execute(*args)
    @commands << args.join(' ')
  end
end
