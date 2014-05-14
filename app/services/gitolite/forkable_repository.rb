module Gitolite
  class ForkableRepository < SimpleDelegator
    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def create_fork(target_path)
      shell.execute("ssh git@#{host} fork #{path} #{target_path}")
    end

    private

    attr_reader :repository, :shell
  end
end
