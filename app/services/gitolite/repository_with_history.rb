module Gitolite
  class RepositoryWithHistory < SimpleDelegator
    def initialize(repository, shell)
      super(repository)
      @repository = repository
      @shell = shell
    end

    def head
      repository.in_local_clone do
        shell.execute('git rev-parse HEAD')
      end
    end

    private

    attr_reader :repository, :shell
  end
end
