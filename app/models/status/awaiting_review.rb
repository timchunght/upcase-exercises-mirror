class Status::AwaitingReview
  pattr_initialize :review

  def applicable?
    review.user_has_reviewed_other_solution? &&
      review.user_is_awaiting_review?
  end

  def to_partial_path
    'statuses/awaiting_review'
  end
end
