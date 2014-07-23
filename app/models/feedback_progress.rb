# Query methods for a user's commenting actions in a review.
class FeedbackProgress
  pattr_initialize [:exercise!, :reviewer!, :submitted_solution]

  def user_is_awaiting_review?
    submitted_solution? && submitted_solution_has_no_comments?
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
    submitted_solution? &&
      submitted_solution.has_comments?
  end

  def submitted_solution?
    submitted_solution.present?
  end
end
