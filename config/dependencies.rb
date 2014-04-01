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
    config_committer_factory: config[:config_committer],
    host: ENV['GIT_SERVER_HOST'],
    shell: config[:shell]
  )
end
.factory :config_committer do |config|
  GitoliteConfigCommitter.new(
    host: ENV['GIT_SERVER_HOST'],
    shell: config[:shell],
    writer: config[:config_writer]
  )
end
.service :config_writer do |config|
  GitoliteConfigWriter.new(ENV['PUBLIC_KEY'], config[:sources])
end
.service :sources do |config|
  SourceCollection.new(config[:exercises], config[:git_server])
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
