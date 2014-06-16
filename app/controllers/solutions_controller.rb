class SolutionsController < ApplicationController
  def new
    @overview = dependencies[:current_overview]
    render layout: false
  end

  def create
    participation_by_current_user.find_or_create_solution
    redirect_to exercise_solution_path(exercise, current_user)
  end

  def show
    if can_view_solution?
      @review = review_solution_by(user_from_params)
    else
      redirect_to exercise
    end
  end

  private

  def participation_by_current_user
    participation_by(current_user)
  end

  def participation_by(user)
    dependencies[:participation].new(
      exercise: exercise,
      user: user
    )
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def can_view_solution?
    admin_user? || solved_by_current_user?
  end

  def admin_user?
    current_user.admin?
  end

  def solved_by_current_user?
    participation_by_current_user.has_solution?
  end

  def review_solution_by(user)
    dependencies[:review].new(
      exercise: exercise,
      viewed_solution: participation_by(user).find_solution,
      submitted_solution: solution_by_current_user,
      reviewer: current_user,
    )
  end

  def solution_by_current_user
    if solved_by_current_user?
      participation_by_current_user.find_solution
    end
  end

  def user_from_params
    User.find(params[:id])
  end
end
