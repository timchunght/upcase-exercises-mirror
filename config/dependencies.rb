factory :authenticator_factory do |container|
  Authenticator.new(container[:auth_hash])
end

service :git_server do |container|
  Git::BackgroundServer.new(
    container[:immediate_git_server],
    container[:git_server_job_factory]
  )
end

service :immediate_git_server do |container|
  Gitolite::Server.new(
    config_committer: container[:config_committer],
    observer: container[:git_observer],
    repository_finder: container[:repository_finder]
  )
end

factory :git_server_job_factory do |container|
  container[:queue].enqueue(
    Git::ServerJob.new(
      method_name: container[:method_name],
      data: container[:data],
    )
  )
end

service :git_observer do |container|
  CompositeObserver.new([
    Git::CloneObserver.new(clones: container[:clones]),
    Git::LoggingObserver.new(
      container[:prefixed_logger_factory].new(prefix: "GIT: ")
    )
  ])
end

service :clones do |container|
  Clone.all
end

service :queue do |container|
  Delayed::Job
end

service :config_committer do |container|
  Gitolite::ConfigCommitter.new(
    repository_factory: container[:repository_factory],
    config_writer: container[:config_writer]
  )
end

service :config_writer do |container|
  Gitolite::ConfigWriter.new(ENV["PUBLIC_KEY"], container[:sources])
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
  ENV["SHELL_CLASS"].constantize.new
end

decorate :shell do |shell, container|
  Gitolite::IdentifiedShell.new(shell, ENV["IDENTITY"])
end

factory :participation_factory do |container|
  Participation.new(
    clones: CloneQuery.new(
      DecoratingRelation.new(
        container[:exercise].clones,
        :clone,
        container[:git_clone_factory]
      )
    ),
    exercise: container[:exercise],
    git_server: container[:git_server],
    user: container[:user]
  )
end

factory :git_clone_factory do |container|
  Git::Clone.new(container[:clone], container[:git_server])
end

factory :repository_factory do |container|
  Git::Repository.new(host: ENV["GIT_SERVER_HOST"], path: container[:path])
end

service :repository_finder do |container|
  Gitolite::RepositoryFinder.new(container[:repository_factory])
end

decorate :repository_factory do |component, container|
  Gitolite::ClonableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::ForkableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::CommittableRepository.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::RepositoryWithHistory.new(component, container[:shell])
end

decorate :repository_factory do |component, container|
  Gitolite::DiffableRepository.new(component, container[:shell])
end

factory :review_factory do |container|
  revision = container[:git_revision_factory].new(
    comments: container[:viewed_solution].comments,
  )

  Review.new(
    comment_locator: container[:comment_locator_factory].new(
      comments: container[:viewed_solution].comments,
      revision: revision,
    ),
    exercise: container[:exercise],
    solutions: container[:reviewable_solutions_factory].new(
      solutions: container[:exercise].solutions
    ),
    status_factory: container[:status_factory],
    submitted_solution: container[:submitted_solution],
    viewed_solution: container[:viewed_solution],
    reviewer: container[:reviewer],
    revision: revision,
    revisions: DecoratingRelation.new(
      ChronologicalQuery.new(container[:viewed_solution].revisions),
      :revision,
      container[:numbered_revision_factory]
    )
  )
end

factory :numbered_revision_factory do |container|
  NumberedRevision.new(
    container[:revision],
    container[:viewed_solution].revisions
  )
end

factory :git_revision_factory do |container|
  Git::Revision.new(
    container[:revision],
    container[:diff_parser_factory]
  )
end

factory :status_factory do |container|
  Status::Finder.new([
    Status::AllStepsCompleted.new(container[:review]),
    Status::AwaitingReview.new(container[:review]),
    Status::ReviewingOtherSolution.new(container[:review]),
    Status::SubmittedSolution.new,
  ]).find
end

factory :diff_parser_factory do |container|
  Git::DiffParser.new(container[:diff], container[:diff_file_factory])
end

factory :diff_file_factory do |container|
  Git::DiffFile.new(
    container[:diff_line_factory],
    ENV.fetch("MAX_DIFF_LINES").to_i
  )
end

decorate :diff_file_factory do |file, container|
  CommentableFile.new(
    file,
    container[:comment_locator_factory].new(
      revision: container[:revision]
    )
  )
end

factory :diff_line_factory do |container|
  Git::DiffLine.new(
    text: container[:text],
    changed: container[:changed],
    file_name: container[:file_name],
    number: container[:number]
  )
end

factory :comment_locator_factory do |container|
  CommentLocator.new(
    revision: container[:revision],
    comments: ChronologicalQuery.new(container[:comments])
  )
end

factory :reviewable_solutions_factory do |container|
  ReviewableSolutionQuery.new(container[:solutions])
end

service :solutions do |container|
  Solution.all.includes(:user, :exercise).limit(50)
end

decorate :diff_line_factory do |diff_line, container|
  CommentableLine.new(
    diff_line,
    container[:comment_locator_factory].new(
      revision: container[:revision]
    )
  )
end

factory :prefixed_logger_factory do |container|
  PrefixedLogger.new(container[:logger], container[:prefix])
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

factory :comment_notification_factory do |container|
  container[:mailer].comment(
    author: container[:comment].user,
    comment: container[:comment],
    recipient: container[:comment].solution_submitter,
    exercise: container[:comment].exercise,
    submitter: container[:comment].solution_submitter,
  )
end

decorate :comment_notification_factory do |message, container|
  FilteredMessage.new(
    message,
    filter: container[:comment].user,
    recipient: container[:comment].solution_submitter,
  )
end

service :current_public_keys do |container|
  container[:current_user].public_keys
end

decorate :current_public_keys do |public_keys, container|
  Gitolite::FingerprintedPublicKeyCollection.new(
    public_keys,
    container[:fingerprinter]
  )
end

service :fingerprinter do |container|
  Gitolite::Fingerprinter.new(container[:shell])
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
  container[:participation_factory].new(
    exercise: container[:requested_exercise],
    user: container[:current_user]
  )
end

service :current_overview do |container|
  container[:overview_factory].new(
    exercise: container[:requested_exercise],
    participation: container[:current_participation],
    user: container[:current_user],
  )
end

factory :overview_factory do |container|
  revision = container[:git_revision_factory].new(
    comments: Comment.none,
    revision: container[:participation].latest_revision,
  )

  Overview.new(
    exercise: container[:exercise],
    participation: container[:participation],
    revision: revision,
    user: container[:user],
  )
end

service :clearance_session do |container|
  container[:rack_env][:clearance]
end

factory :event_tracker_factory do |container|
  EventTracker.new(
    container[:user],
    container[:exercise],
    container[:analytics_backend]
  )
end

service :analytics_backend do |container|
  if ENV["SEGMENT_IO_KEY"].present?
    Segment::Analytics.new(write_key: ENV["SEGMENT_IO_KEY"])
  else
    FakeAnalyticsBackend.new
  end
end

decorate :participation_factory do |participation, container|
  TrackingParticipation.new(
    participation,
    container[:event_tracker_factory].new(user: container[:user])
  )
end

service :exercise do |container|
  container[:requested_exercise]
end
