class ExercisesController < ApplicationController
  def show
    @overview = dependencies[:current_overview]
    track_exercise_visit
  end

  private

  def track_exercise_visit
    event_tracker.track_exercise_visit
  end

  def event_tracker
    dependencies[:event_tracker].new(user: current_user)
  end
end
