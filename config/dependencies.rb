factory :authenticator do |container|
  Authenticator.new(container[:auth_hash])
end

decorate :authenticator do |component, container|
  Gitolite::PublicKeyAuthenticator.new(
    component,
    container[:auth_hash],
    container[:public_key_syncronizer]
  )
end

factory :public_key_syncronizer do |container|
  Gitolite::PublicKeySyncronizer.new(
    server: container[:git_server],
    local_keys: container[:local_keys],
    remote_keys: container[:remote_keys],
    user: container[:user]
  )
end

service :git_server do |container|
  Gitolite::Server.new(
    config_committer: container[:config_committer],
    repository_finder: container[:repository_finder]
  )
end

service :config_committer do |container|
  Gitolite::ConfigCommitter.new(
    repository_factory: container[:repository],
    config_writer: container[:config_writer]
  )
end

service :config_writer do |container|
  Gitolite::ConfigWriter.new(ENV['PUBLIC_KEY'], container[:sources])
end

service :sources do |container|
  Gitolite::SourceCollection.new(
    container[:exercises],
    container[:repository_finder]
 )
end

service :exercises do |container|
  Exercise.alphabetical
end

decorate :exercises do |exercises, container|
  Gitolite::ReloadingCollection.new(exercises)
end

service :shell do |container|
  ENV['SHELL_CLASS'].constantize.new
end

decorate :shell do |shell, container|
  Gitolite::IdentifiedShell.new(shell, ENV['IDENTITY'])
end

factory :participation do |container|
  Participation.new(
    exercise: container[:exercise],
    git_server: container[:git_server],
    user: container[:user]
  )
end

decorate :participation do |participation, container|
  ImportableParticipation.new(
    participation,
    git_server: container[:git_server],
    shell: container[:shell]
  )
end

factory :repository do |container|
  Git::Repository.new(host: ENV['GIT_SERVER_HOST'], path: container[:path])
end

service :repository_finder do |container|
  Gitolite::RepositoryFinder.new(container[:repository])
end

decorate :repository do |component, container|
  Gitolite::ClonableRepository.new(component, container[:shell])
end

decorate :repository do |component, container|
  Gitolite::ForkableRepository.new(component, container[:shell])
end

decorate :repository do |component, container|
  Gitolite::CommittableRepository.new(component, container[:shell])
end

decorate :repository do |component, container|
  Gitolite::RepositoryWithHistory.new(component, container[:shell])
end

decorate :repository do |component, container|
  Gitolite::DiffableRepository.new(component, container[:shell])
end

factory :review do |container|
  viewed_solution = Git::Solution.new(
    container[:viewed_solution],
    container[:diff_parser]
  )

  Review.new(
    exercise: container[:exercise],
    solutions: ReviewableSolutionQuery.new(container[:exercise].solutions),
    submitted_solution: container[:submitted_solution],
    viewed_solution: viewed_solution
  )
end

factory :diff_parser do |container|
  Git::DiffParser.new(container[:diff], container[:diff_file])
end

factory :diff_file do |container|
  Git::DiffFile.new(container[:diff_line])
end

factory :diff_line do |container|
  Git::DiffLine.new(container[:text], container[:changed])
end

factory :github_exercise do |container|
  Github::Exercise.new(
    github_client: container[:github_client],
    github_repository: container[:github_repository],
    local_exercise: container[:local_exercise],
    solution_factory: container[:github_solution],
  )
end

service :github_client do |container|
  Octokit::Client.new(
    login: ENV['GITHUB_USER'],
    password: ENV['GITHUB_PASSWORD'],
  )
end

factory :github_solution do |container|
  Github::Solution.new(
    github_client: container[:github_client],
    local_exercise: container[:local_exercise],
    logger: container[:logger],
    participation_factory: container[:participation],
    pull_request: container[:pull_request],
  )
end

service :logger do |container|
  Rails.logger
end
