class StatusUpdater
  pattr_initialize [:user!, :exercise!, :upcase_client!]

  def solution_submitted
    update_with('Submitted')
  end

  def clone_created
    update_with('Started')
  end

  def revision_submitted
    update_with('Pushed')
  end

  def comment_created
    update_with('Reviewed')
  end

  private

  def update_with(state)
    upcase_client.update_status(exercise.uuid, state)
  end
end
