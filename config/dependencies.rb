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
  Git::BackgroundServer.new(
    container[:immediate_git_server],
    container[:git_server_job]
  )
end

service :immediate_git_server do |container|
  Gitolite::Server.new(
    config_committer: container[:config_committer],
    observer: container[:git_observer],
    repository_finder: container[:repository_finder]
  )
end

factory :git_server_job do |container|
  container[:queue].enqueue(
    Git::ServerJob.new(
      method_name: container[:method_name],
      data: container[:data],
    )
  )
end

service :git_observer do |container|
  Git::Observer.new(clones: container[:clones])
end

service :clones do |container|
  Clone.all
end

service :queue do |container|
  Delayed::Job
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
    clones: CloneQuery.new(
      DecoratingRelation.new(
        container[:exercise].clones,
        :clone,
        container[:git_clone]
      )
    ),
    exercise: container[:exercise],
    git_server: container[:git_server],
    user: container[:user]
  )
end

factory :git_clone do |container|
  Git::Clone.new(container[:clone], container[:git_server])
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
    comment_locator: container[:comment_locator].new(
      comments: container[:viewed_solution].comments,
      revision: container[:viewed_solution].latest_revision,
    ),
    exercise: container[:exercise],
    solutions: container[:reviewable_solutions].new(
      solutions: container[:exercise].solutions
    ),
    status_factory: container[:status],
    submitted_solution: container[:submitted_solution],
    viewed_solution: viewed_solution,
    reviewer: container[:current_user]
  )
end

factory :status do |container|
  Status::Finder.new([
    Status::AllStepsCompleted.new(container[:review]),
    Status::AwaitingReview.new(container[:review]),
    Status::ReviewingOtherSolution.new(container[:review]),
    Status::SubmittedSolution.new,
  ]).find
end

factory :diff_parser do |container|
  Git::DiffParser.new(container[:diff], container[:diff_file])
end

factory :diff_file do |container|
  Git::DiffFile.new(container[:diff_line])
end

factory :diff_line do |container|
  Git::DiffLine.new(
    text: container[:text],
    changed: container[:changed],
    file_name: container[:file_name],
    number: container[:number]
  )
end

factory :comment_locator do |container|
  CommentLocator.new(
    revision: container[:revision],
    comments: ChronologicalQuery.new(container[:viewed_solution].comments)
  )
end

factory :reviewable_solutions do |container|
  ReviewableSolutionQuery.new(container[:solutions])
end

service :solutions do |container|
  Solution.all.includes(:user, :exercise).limit(50)
end

decorate :diff_line do |diff_line, container|
  CommentableLine.new(
    diff_line,
    container[:comment_locator].new(
      revision: container[:viewed_solution].latest_revision
    ),
    container[:viewed_solution]
  )
end

service :logger do |container|
  Rails.logger
end

service :error_notifier do |container|
  Airbrake
end

service :mailer do |container|
  Mailer
end

decorate :mailer do |mailer, container|
  DelayedMailer.new(mailer)
end

factory :comment_notification do |container|
  container[:mailer].comment(
    author: container[:comment].user,
    comment: container[:comment],
    recipient: container[:comment].solution_submitter,
    exercise: container[:comment].exercise,
    submitter: container[:comment].solution_submitter,
  )
end

decorate :comment_notification do |message, container|
  FilteredMessage.new(
    message,
    filter: container[:comment].user,
    recipient: container[:comment].solution_submitter,
  )
end

service :current_public_keys do |container|
  container[:current_user].public_keys
end

service :current_user do |container|
  container[:clearance_session].current_user
end

service :request do |container|
  ActionDispatch::Request.new(container[:rack_env])
end

service :requested_exercise do |container|
  params = container[:request]
  exercise_id = params[:exercise_id] || params[:id]
  Exercise.find(exercise_id)
end

service :current_participation do |container|
  container[:participation].new(
    exercise: container[:requested_exercise],
    user: container[:current_user]
  )
end

service :current_overview do |container|
  container[:overview].new(
    exercise: container[:requested_exercise],
    participation: container[:current_participation],
    user: container[:current_user],
  )
end

factory :overview do |container|
  Overview.new(
    exercise: container[:exercise],
    participation: container[:participation],
    user: container[:user],
  )
end

service :clearance_session do |container|
  container[:rack_env][:clearance]
end

factory :event_tracker do |container|
  EventTracker.new(
    container[:user],
    container[:exercise],
    container[:analytics_backend]
  )
end

service :analytics_backend do |container|
  if ENV['SEGMENT_IO_KEY'].present?
    Segment::Analytics.new(write_key: ENV['SEGMENT_IO_KEY'])
  else
    FakeAnalyticsBackend.new
  end
end

decorate :participation do |participation, container|
  TrackingParticipation.new(
    participation,
    container[:event_tracker].new(user: container[:user])
  )
end

service :exercise do |container|
  container[:requested_exercise]
end
