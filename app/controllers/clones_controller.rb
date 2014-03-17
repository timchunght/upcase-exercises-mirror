class ClonesController < ApplicationController
  def create
    exercise = Exercise.find(params[:exercise_id])
    clone = exercise.find_or_create_clone_for(current_user)
    redirect_to clone
  end

  def show
    @clone = Clone.find(params[:id])
  end
end
