# Solutions and files to be displayed to a user performing a review.
class Review
  pattr_initialize([
    :exercise,
    :reviewer,
    :solutions,
    :status_factory,
    :viewed_solution,
    :feedback
  ])
  attr_reader :exercise, :viewed_solution, :feedback, :solutions
  delegate(
    :submitted_solution,
    :solutions_by_other_users,
    :assigned_solver,
    :assigned_solver_username,
    to: :solutions
  )

  def status
    status_factory.new(review: self)
  end

  def viewing_other_solution?
    viewed_solution != submitted_solution
  end

  def user_is_awaiting_review?
    if submitted_solution.present?
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
end
