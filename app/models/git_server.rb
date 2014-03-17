class GitServer
  ADMIN_REPO_NAME = 'gitolite-admin'
  SOURCE_ROOT = 'sources'

  def initialize(shell, host, config_directory)
    @shell = shell
    @host = host
    @config_directory = config_directory
  end

  def clone(exercise, user)
    Repository.new(host: host, path: "#{user.username}/#{exercise.slug}")
  end

  def create_clone(exercise, user)
    source = source(exercise)
    clone = clone(exercise, user)
    @shell.execute("ssh git@#{@host} fork #{source.path} #{clone.path}")
  end

  def source(exercise)
    Repository.new(host: host, path: "#{SOURCE_ROOT}/#{exercise.slug}")
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
