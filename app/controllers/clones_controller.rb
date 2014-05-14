class ClonesController < ApplicationController
  def create
    participation.find_or_create_clone
    redirect_to exercise_clone_url(exercise)
  end

  def show
    clone = participation.find_clone
    @clone = Git::Clone.new(
      clone,
      dependencies[:git_server]
    )
  end

  private

  def participation
    dependencies[:participation].new(
      exercise: exercise,
      user: current_user
    )
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end
end
