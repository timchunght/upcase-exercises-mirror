class GitoliteConfigCommitter
  ADMIN_REPO_NAME = 'gitolite-admin'.freeze

  def initialize(attributes)
    @host = attributes[:host]
    @shell = attributes[:shell]
    @writer = attributes[:writer]
  end

  def write(message)
    commit_creator.commit(message) { write_config }
  end

  private

  def commit_creator
    CommitCreator.new(shell, admin_repository)
  end

  def write_config
    @writer.write
  end

  def admin_repository
    Repository.new(host: host, path: ADMIN_REPO_NAME)
  end

  attr_reader :host, :shell
end
