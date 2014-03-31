# Finds and decorates related solutions for the solution review page.
class ReviewableSolution < SimpleDelegator
  def initialize(attributes)
    super(attributes[:solution])
    @exercise = attributes.fetch(:exercise)
    @solution = attributes.fetch(:solution)
    @user = attributes.fetch(:user)
  end

  def assigned_solution
    solutions_by_other_users.detect(&:assigned?)
  end

  def solutions_by_other_users
    decorate_solutions(@exercise.solutions - [solution_for_user])
  end

  def my_solution
    decorate_solution solution_for_user
  end

  private

  def solution_for_user
    @exercise.find_solution_for(@user)
  end

  def decorate_solutions(solutions)
    solutions.each_with_index.map do |solution, index|
      decorate_solution solution, index == 0
    end
  end

  def decorate_solution(solution, assigned = false)
    ViewableSolution.new(
      solution,
      active: solution == @solution,
      assigned: assigned
    )
  end
end
