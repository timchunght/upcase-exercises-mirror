class SolutionsController < ApplicationController
  def new
    @overview = dependencies[:current_overview]
  end

  def create
    participation.find_or_create_solution
    redirect_to(
      exercise_solution_path(
        exercise,
        review.assigned_solver
      )
    )
  end

  private

  def assigned_solver
    review.assigned_solver
  end

  def participation
    @participation ||= dependencies[:participation_factory].new(
      exercise: exercise,
      user: current_user
    )
  end

  def exercise
    @exercise ||= Exercise.find(params[:exercise_id])
  end

  def solution
    participation.find_solution
  end

  def review
    @review ||= dependencies[:review_factory].new(
      exercise: exercise,
      viewed_solution: participation.find_solution,
      submitted_solution: solution,
      reviewer: current_user,
      revision: participation.latest_revision
    )
  end
end
