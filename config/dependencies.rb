factory :authenticator do |config|
  Authenticator.new(config[:auth_hash])
end
.decorate :authenticator do |component, config|
  PublicKeyAuthenticator.new(
    component,
    config[:auth_hash],
    config[:public_key_syncronizer]
  )
end
.factory :public_key_syncronizer do |config|
  PublicKeySyncronizer.new(
    git_server: config[:git_server],
    local_keys: config[:local_keys],
    remote_keys: config[:remote_keys],
    user: config[:user]
  )
end
.service :git_server do |config|
  GitServer.new(
    config_committer: config[:config_committer],
    repository_finder: config[:repository_finder]
  )
end
.service :config_committer do |config|
  GitoliteConfigCommitter.new(
    repository_factory: config[:repository],
    config_writer: config[:config_writer]
  )
end
.service :config_writer do |config|
  GitoliteConfigWriter.new(ENV['PUBLIC_KEY'], config[:sources])
end
.service :sources do |config|
  SourceCollection.new(config[:exercises], config[:repository_finder])
end
.service :exercises do |config|
  Exercise.alphabetical
end
.decorate :exercises do |exercises, config|
  ReloadingCollection.new(exercises)
end
.service :shell do |config|
  ENV['SHELL_CLASS'].constantize.new
end
.decorate :shell do |shell, config|
  IdentifiedShell.new(shell, ENV['IDENTITY'])
end
.service :git_observer do |config|
  GitObserver.new(config[:git_server])
end
.factory :participation do |config|
  Participation.new(
    config[:exercise],
    config[:user],
    config[:git_observer]
  )
end
.factory :repository do |config|
  Repository.new(host: ENV['GIT_SERVER_HOST'], path: config[:path])
end
.service :repository_finder do |config|
  RepositoryFinder.new(config[:repository])
end
.decorate :repository do |component, config|
  ClonableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  ForkableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  CommittableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  RepositoryWithHistory.new(component, config[:shell])
end
.decorate :repository do |component, config|
  DiffableRepository.new(component, config[:shell])
end
