class EventTracker
  pattr_initialize :user, :exercise, :analytics_backend

  def track_solution_submission
    track('Submitted Solution')
  end

  def track_clone_creation
    track('Started Exercise')
  end

  private

  def track(event_name)
    analytics_backend.track(
      user_id: user.id,
      event: event_name,
      properties: { exercise_slug: exercise.slug },
      integrations: { all: false, KISSmetrics: true }
    )
  end
end
