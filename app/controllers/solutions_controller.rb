class SolutionsController < ApplicationController
  def create
    exercise.find_or_create_solution_for(current_user)
    redirect_to exercise_solution_path(
      exercise,
      reviewable_solution_by(current_user).assigned_solution
    )
  end

  def show
    if solved_by_current_user?
      @solution = reviewable_solution_by(user_from_params)
    else
      redirect_to exercise
    end
  end

  private

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def solved_by_current_user?
    exercise.solved_by?(current_user)
  end

  def reviewable_solution_by(user)
    ReviewableSolution.new(
      exercise: exercise,
      solution: find_solution_by(user),
      user: current_user
    )
  end

  def find_solution_by(user)
    exercise.find_solution_for(user)
  end

  def user_from_params
    User.find(params[:id])
  end
end
