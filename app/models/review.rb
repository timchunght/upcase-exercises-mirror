# Solutions and files to be displayed to a user performing a review.
class Review
  pattr_initialize([
    :exercise,
    :solutions,
    :submitted_solution,
    :viewed_solution
  ])
  attr_reader :exercise, :viewed_solution

  def assigned_solution
    solutions_by_other_users.detect(&:assigned?) || submitted_solution
  end

  def assigned_solver
    assigned_solution.user
  end

  def has_solutions_by_other_users?
    solutions_by_other_users.present?
  end

  def solutions_by_other_users
    decorate_solutions(solutions.to_a - [submitted_solution])
  end

  def my_solution
    decorate_solution submitted_solution
  end

  def submitted?
    submitted_solution.present?
  end

  def files
    viewed_solution.files
  end

  def comments
    viewed_solution.comments
  end

  def latest_revision
    viewed_solution.latest_revision
  end

  private

  def decorate_solutions(solutions)
    solutions.each_with_index.map do |solution, index|
      decorate_solution solution, index == 0
    end
  end

  def decorate_solution(solution, assigned = false)
    ViewableSolution.new(
      solution,
      active: solution.id == viewed_solution.id,
      assigned: assigned
    )
  end
end
