class Api::PushesController < ApplicationController
  skip_before_filter :authorize, :verify_authenticity_token
  http_basic_authenticate_with(
    name: ENV["API_USERNAME"],
    password: ENV["API_PASSWORD"]
  )

  def create
    trap_not_found do
      participation.push_to_clone
      render_success
    end
  end

  private

  def trap_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def participation
    exercise = Exercise.find(params[:exercise_id])
    user = User.find(params[:user_id])
    dependencies[:participation_factory].new(exercise: exercise, user: user)
  end

  def render_success
    render nothing: true, status: :created
  end

  def render_not_found
    render nothing: true, status: :not_found
  end
end
