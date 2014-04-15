# Solutions and files to be displayed to a user performing a review.
class Review
  pattr_initialize [:exercise, :submitted_solution, :viewed_solution]
  attr_reader :exercise

  def assigned_solution
    solutions_by_other_users.detect(&:assigned?)
  end

  def assigned_solver
    assigned_solution.user
  end

  def solutions_by_other_users
    decorate_solutions(exercise.solutions - [submitted_solution])
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
