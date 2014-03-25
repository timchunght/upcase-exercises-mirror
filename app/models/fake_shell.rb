class FakeShell
  attr_reader :commands

  def initialize
    @commands = []
  end

  def execute(*args)
    command = args.join(' ')
    @commands << command
    self.class.stubs.run(command)
  end

  def self.with_stubs
    yield stubs
  ensure
    @stubs = Stubs.new
  end

  private

  def self.stubs
    @stubs ||= Stubs.new
  end

  class Stubs
    def initialize
      @stubs = {}
    end

    def add(pattern, &result)
      @stubs[pattern] = result
    end

    def run(command)
      @stubs.each do |pattern, result|
        if match = pattern.match(command)
          result.call(*match.captures)
        end
      end
    end
  end
end
