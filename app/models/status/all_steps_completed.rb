class Status::AllStepsCompleted
  pattr_initialize :review

  def applicable?
    review.user_has_given_and_received_review?
  end

  def to_partial_path
    'statuses/all_steps_completed'
  end
end
