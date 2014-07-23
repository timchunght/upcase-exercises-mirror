class Status::AwaitingReview
  pattr_initialize :feedback_progress

  def applicable?
    feedback_progress.user_has_reviewed_other_solution? &&
      feedback_progress.user_is_awaiting_review?
  end

  def to_partial_path
    'statuses/awaiting_review'
  end
end
