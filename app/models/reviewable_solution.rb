# Finds and decorates related solutions for the solution review page.
class ReviewableSolution < SimpleDelegator
  def initialize(attributes)
    super(attributes[:viewed_solution])
    @exercise = attributes.fetch(:exercise)
    @viewed_solution = attributes.fetch(:viewed_solution)
    @submitted_solution = attributes.fetch(:submitted_solution)
  end

  def assigned_solution
    solutions_by_other_users.detect(&:assigned?)
  end

  def solutions_by_other_users
    decorate_solutions(@exercise.solutions - [@submitted_solution])
  end

  def my_solution
    decorate_solution @submitted_solution
  end

  def viewed_snapshot
    decorate_snapshot @viewed_solution.snapshot
  end

  def files
    viewed_snapshot.files
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
      active: solution == @viewed_solution,
      assigned: assigned
    )
  end

  def decorate_snapshot(snapshot)
    ViewableSnapshot.new(snapshot)
  end
end
