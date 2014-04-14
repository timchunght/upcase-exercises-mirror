# Performs modifications to a remote repository.
#
# Given a shell to execute commands, and a repository to execute commands
# against, CommittableRepository will clone the repository locally, change to
# the repository's working directory, yield to allow the consumer to perform
# modifications, commit those changes, and then push them to the remote
# repository.
class CommittableRepository < SimpleDelegator
  def initialize(repository, shell)
    super(repository)
    @shell = shell
    @repository = repository
  end

  def commit(message)
    repository.in_local_clone do
      yield
      add_to_index
      create_commit(message)
      push
    end
  end

  private

  attr_reader :repository, :shell

  def add_to_index
    shell.execute('git add -A')
  end

  def create_commit(message)
    shell.execute(%{git commit -m "#{message}"})
  end

  def push
    shell.execute('git push')
  end
end
