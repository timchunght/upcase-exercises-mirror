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
    @shell.execute("command ssh git@#{@host} fork #{source.path} #{clone.path}")
  end

  def source(exercise)
    Repository.new(host: host, path: "#{SOURCE_ROOT}/#{exercise.slug}")
  end

  def create_exercise(repository)
    pull_admin_repository
    add_configuration_entry("Add exercise: #{repository.name}")
    push_admin_repository
  end

  private

  attr_reader :shell, :config_directory, :host

  def has_gitolite_repo?
    File.directory?(gitolite_repo_path)
  end

  def in_admin_repository(&block)
    Dir.chdir(gitolite_repo_path, &block)
  end

  def clone_admin_repository
    if !has_gitolite_repo?
      cmd = "git clone git@#{host}:#{ADMIN_REPO_NAME} #{gitolite_repo_path}"
      shell.execute(cmd)
    end
  end

  def pull_admin_repository
    clone_admin_repository

    in_admin_repository do
      shell.execute('git pull')
    end
  end

  def push_admin_repository
    in_admin_repository do
      shell.execute('git push')
    end
  end

  def add_configuration_entry(commit_message)
    in_admin_repository do
      GitoliteConfig.new(gitolite_repo_path).write
      shell.execute('git add conf/gitolite.conf')
      shell.execute("git commit -m '#{commit_message}'")
    end
  end

  def gitolite_repo_path
    File.join(config_directory, ADMIN_REPO_NAME)
  end
end
