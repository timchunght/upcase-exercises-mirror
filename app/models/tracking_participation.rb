class TrackingParticipation < SimpleDelegator
  def initialize(participation, event_tracker)
    super(participation)
    @event_tracker = event_tracker
  end

  def create_clone
    event_tracker.track_clone_creation
    super
  end

  def find_or_create_solution
    event_tracker.track_solution_submission
    super
  end

  def push_to_clone
    event_tracker.track_revision_submission
    super
  end

  private

  attr_reader :event_tracker
end
