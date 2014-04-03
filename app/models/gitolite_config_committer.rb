# Uses a writer and a CommitCreator to write changes to the Gitolite
# configuration repository.
class GitoliteConfigCommitter
  ADMIN_REPO_NAME = 'gitolite-admin'.freeze

  pattr_initialize [:host, :shell, :writer]

  def write(message)
    commit_creator.commit(message) { write_config }
  end

  private

  def commit_creator
    CommitCreator.new(shell, admin_repository)
  end

  def write_config
    writer.write
  end

  def admin_repository
    Repository.new(host: host, path: ADMIN_REPO_NAME)
  end
end
