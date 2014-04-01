class SolutionsController < ApplicationController
  def create
    participation_by(current_user).find_or_create_solution
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

  def participation_by(user)
    dependencies[:participation].new(
      exercise: exercise,
      user: user
    )
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def solved_by_current_user?
    participation_by(current_user).has_solution?
  end

  def reviewable_solution_by(user)
    ReviewableSolution.new(
      exercise: exercise,
      viewed_solution: participation_by(user).find_solution,
      submitted_solution: participation_by(current_user).find_solution
    )
  end

  def user_from_params
    User.find(params[:id])
  end
end
