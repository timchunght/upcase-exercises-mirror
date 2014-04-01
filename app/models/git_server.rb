# Encapsulates paths to repositories and commands to manipulate them.
class GitServer
  SOURCE_ROOT = 'sources'

  def initialize(attributes)
    @config_committer_factory = attributes[:config_committer_factory]
    @shell = attributes[:shell]
    @host = attributes[:host]
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

  def create_exercise(repository)
    config_committer.write("Add exercise: #{repository.name}")
  end

  def add_key(username)
    config_committer.write("Add public key for user: #{username}")
  end

  private

  attr_reader :config_committer_factory, :shell, :host

  def config_committer
    config_committer_factory.new(git_server: self)
  end
end
