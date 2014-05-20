class Status::SubmittedSolution
  def applicable?
    true
  end

  def to_partial_path
    'statuses/submitted_solution'
  end
end
