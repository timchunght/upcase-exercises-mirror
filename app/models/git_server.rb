class GitServer
  ADMIN_REPO_NAME = 'gitolite-admin'

  def initialize(shell, host, config_directory)
    @shell = shell
    @host = host
    @config_directory = config_directory
  end

  def exercise_url(repository)
    "git@#{host}:#{repository.exercise_path}.git"
  end

  def has_gitolite_repo?
    File.directory?(gitolite_repo_path)
  end

  private

  attr_reader :shell, :host, :config_directory

  def gitolite_repo_path
    File.join(config_directory, ADMIN_REPO_NAME)
  end
end
