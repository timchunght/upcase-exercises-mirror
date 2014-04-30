module Gitolite
  # Fake implementation of a shell to avoid running slow or destructive
  # commands during tests.
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

    def self.stub
      @stubs = Stubs.new
      yield stubs
    end

    private

    def self.stubs
      @stubs ||= Stubs.new
    end

    class Stubs
      def initialize
        @stubs = {}
      end

      def add(pattern, &handler)
        @stubs[pattern] = handler
      end

      def run(command)
        pattern, handler = find(command)
        if pattern
          match = pattern.match(command)
          normalize_output handler.call(*match.captures)
        end
      end

      private

      def find(command)
        @stubs.find do |pattern, _|
          pattern =~ command
        end
      end

      def normalize_output(result)
        output = result.to_s
        if output.present?
          "#{output.rstrip}\n"
        else
          ''
        end
      end
    end
  end
end
