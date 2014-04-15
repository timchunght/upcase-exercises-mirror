factory :authenticator do |config|
  Authenticator.new(config[:auth_hash])
end
.decorate :authenticator do |component, config|
  Gitolite::PublicKeyAuthenticator.new(
    component,
    config[:auth_hash],
    config[:public_key_syncronizer]
  )
end
.factory :public_key_syncronizer do |config|
  Gitolite::PublicKeySyncronizer.new(
    server: config[:git_server],
    local_keys: config[:local_keys],
    remote_keys: config[:remote_keys],
    user: config[:user]
  )
end
.service :git_server do |config|
  Gitolite::Server.new(
    config_committer: config[:config_committer],
    repository_finder: config[:repository_finder]
  )
end
.service :config_committer do |config|
  Gitolite::ConfigCommitter.new(
    repository_factory: config[:repository],
    config_writer: config[:config_writer]
  )
end
.service :config_writer do |config|
  Gitolite::ConfigWriter.new(ENV['PUBLIC_KEY'], config[:sources])
end
.service :sources do |config|
  Gitolite::SourceCollection.new(config[:exercises], config[:repository_finder])
end
.service :exercises do |config|
  Exercise.alphabetical
end
.decorate :exercises do |exercises, config|
  Gitolite::ReloadingCollection.new(exercises)
end
.service :shell do |config|
  ENV['SHELL_CLASS'].constantize.new
end
.decorate :shell do |shell, config|
  Gitolite::IdentifiedShell.new(shell, ENV['IDENTITY'])
end
.service :git_observer do |config|
  Git::Observer.new(config[:git_server])
end
.factory :participation do |config|
  Participation.new(
    config[:exercise],
    config[:user],
    config[:git_observer]
  )
end
.factory :repository do |config|
  Git::Repository.new(host: ENV['GIT_SERVER_HOST'], path: config[:path])
end
.service :repository_finder do |config|
  Gitolite::RepositoryFinder.new(config[:repository])
end
.decorate :repository do |component, config|
  Gitolite::ClonableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  Gitolite::ForkableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  Gitolite::CommittableRepository.new(component, config[:shell])
end
.decorate :repository do |component, config|
  Gitolite::RepositoryWithHistory.new(component, config[:shell])
end
.decorate :repository do |component, config|
  Gitolite::DiffableRepository.new(component, config[:shell])
end
.factory :review do |config|
  viewed_solution = Git::Solution.new(
    config[:viewed_solution],
    config[:diff_parser]
  )

  Review.new(
    exercise: config[:exercise],
    submitted_solution: config[:submitted_solution],
    viewed_solution: viewed_solution
  )
end
.factory :diff_parser do |config|
  Git::DiffParser.new(config[:diff], config[:diff_file])
end
.factory :diff_file do |config|
  Git::DiffFile.new
end
