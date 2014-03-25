class GitServer
  ADMIN_REPO_NAME = 'gitolite-admin'
  SOURCE_ROOT = 'sources'

  def initialize(shell, host)
    @shell = shell
    @host = host
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
    CommitCreator.new(shell, Repository.new(host: host, path: ADMIN_REPO_NAME))
      .commit("Add exercise: #{repository.name}") do
        GitoliteConfig.new('.').write
      end
  end

  private

  attr_reader :shell, :host
end
