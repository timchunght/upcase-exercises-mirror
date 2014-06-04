class EventTracker
  pattr_initialize :analytics_backend

  def track_solution_submission(user, exercise)
    analytics_backend.track(
      user_id: user.id,
      event: 'Submitted Solution',
      properties: { exercise: exercise.title },
      integrations: { all: false, KISSmetrics: true }
    )
  end
end
