class ClonesController < ApplicationController
  def create
    exercise = Exercise.find(params[:exercise_id])
    exercise.find_or_create_clone_for(current_user)
    redirect_to exercise_clone_url(exercise)
  end

  def show
    exercise = Exercise.find(params[:exercise_id])
    @clone = exercise.find_clone_for(current_user)
  end
end
