class Status::AllStepsCompleted
  pattr_initialize :progressing_user

  def applicable?
    progressing_user.has_given_and_received_review?
  end

  def to_partial_path
    'statuses/all_steps_completed'
  end
end
