# Performs modifications to a remote repository.
#
# Given a shell to execute commands, and a repository to execute commands
# against, CommitCreator will clone the repository locally, change to the
# repository's working directory, yield to allow the consumer to perform
# modifications, commit those changes, and then push them to the remote
# repository.
class CommitCreator
  pattr_initialize :shell, :clonable

  def commit(message)
    clonable.clone do
      yield
      add_to_index
      create_commit(message)
      push
    end
  end

  private

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
