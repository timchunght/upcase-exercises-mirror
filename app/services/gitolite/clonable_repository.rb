module Gitolite
  class ClonableRepository < SimpleDelegator
    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def in_local_clone
      in_temp_dir do
        shell.execute("git clone #{repository.url} .")
        yield
      end
    end

    private

    attr_reader :repository, :shell

    def in_temp_dir
      Dir.mktmpdir do |path|
        Dir.chdir path do
          yield
        end
      end
    end
  end
end
