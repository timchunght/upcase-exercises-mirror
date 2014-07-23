class Status::ReviewingOtherSolution
  pattr_initialize :solutions
  delegate :assigned_solution, :submitted_solution, to: :solutions

  def applicable?
    solutions.user_has_solution? && viewing_other_solution?
  end

  def to_partial_path
    'statuses/reviewing_other_solution'
  end

  private

  def viewing_other_solution?
    solutions.viewed_solution != solutions.submitted_solution
  end
end
