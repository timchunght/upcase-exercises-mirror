class Api::PushesController < ApplicationController
  skip_before_filter :authorize, :verify_authenticity_token

  def create
    exercise = Exercise.find(params[:exercise_id])
    user = User.find(params[:user_id])
    dependencies[:participation].
      new(exercise: exercise, user: user).
      update_solution
    render nothing: true, status: :created
  end
end
