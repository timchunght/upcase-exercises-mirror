# Solutions and files to be displayed to a user performing a review.
class Review
  pattr_initialize([
    :comment_locator,
    :exercise,
    :reviewer,
    :revision,
    :solutions,
    :status_factory,
    :submitted_solution,
    :viewed_solution,
  ])
  attr_reader :exercise, :viewed_solution

  def assigned_solution
    solutions_by_other_users.detect(&:assigned?) || submitted_solution
  end

  def assigned_solver
    assigned_solution.user
  end

  def assigned_solver_username
    assigned_solution.username
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
    revision.files
  end

  def top_level_comments
    comment_locator.top_level_comments
  end

  def status
    status_factory.new(review: self)
  end

  def viewing_other_solution?
    viewed_solution != submitted_solution
  end

  def user_is_awaiting_review?
    if submitted?
      submitted_solution_has_no_comments?
    end
  end

  def user_has_reviewed_other_solution?
    exercise.has_comments_from?(reviewer)
  end

  def user_has_given_and_received_review?
    user_has_reviewed_other_solution? &&
      user_has_received_review?
  end

  private

  def submitted_solution_has_no_comments?
    !submitted_solution.has_comments?
  end

  def user_has_received_review?
    !user_is_awaiting_review?
  end

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
