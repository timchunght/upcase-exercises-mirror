class Status::SubmittedSolution
  pattr_initialize :review

  def applicable?
    review.user_has_solution?
  end

  def to_partial_path
    'statuses/submitted_solution'
  end
end
