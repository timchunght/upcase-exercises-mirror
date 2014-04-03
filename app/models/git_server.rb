# Encapsulates paths to repositories and commands to manipulate them.
class GitServer
  SOURCE_ROOT = 'sources'

  pattr_initialize [
    :clonable_repository_factory,
    :config_committer_factory,
    :host,
    :shell
  ]

  def clone(exercise, user)
    Repository.new(host: host, path: "#{user.username}/#{exercise.slug}")
  end

  def create_clone(exercise, user)
    source = source(exercise)
    clone = clone(exercise, user)
    fork_repository(source, clone)
    repository_revision(source).head
  end

  def create_diff(solution, clone)
    repository = clone(clone.exercise, clone.user)
    diff_creator(repository).diff(clone.parent_sha)
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

  def config_committer
    config_committer_factory.new(git_server: self)
  end

  def diff_creator(repository)
    clonable = clonable(repository)
    DiffCreator.new(shell, clonable)
  end

  def fork_repository(source, clone)
    shell.execute("ssh git@#{host} fork #{source.path} #{clone.path}")
  end

  def repository_revision(repository)
    clonable = clonable(repository)
    RepositoryRevision.new(shell, clonable)
  end

  def clonable(repository)
    clonable_repository_factory.new(git_server: self, repository: repository)
  end
end
