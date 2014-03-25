class GitServer
  SOURCE_ROOT = 'sources'

  def initialize(attributes)
    @config_committer = attributes[:config_committer]
    @shell = attributes[:shell]
    @host = attributes[:host]
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
    config_committer.write("Add exercise: #{repository.name}")
  end

  private

  attr_reader :config_committer, :shell, :host
end
