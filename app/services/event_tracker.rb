class EventTracker
  pattr_initialize :user, :exercise, :analytics_backend

  def track_solution_submission
    track('Submitted Solution')
  end

  def track_clone_creation
    track('Started Exercise')
  end

  def track_revision_submission
    track('Submitted Revision')
  end

  def track_exercise_visit
    track('Visited Exercise')
  end

  def track_comment_creation(solution)
    track('Left Comment')
    track('Received Feedback', solution.user)
  end

  private

  def track(event_name, user = user)
    analytics_backend.track(
      user_id: user.learn_uid,
      event: event_name,
      properties: { exercise_slug: exercise.slug },
      integrations: { all: true }
    )
  end
end
