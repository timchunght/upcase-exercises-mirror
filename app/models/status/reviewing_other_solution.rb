class Status::ReviewingOtherSolution
  pattr_initialize :review

  def applicable?
    review.viewing_other_solution?
  end

  def to_partial_path
    'statuses/reviewing_solution'
  end
end
