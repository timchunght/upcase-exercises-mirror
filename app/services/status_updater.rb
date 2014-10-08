class StatusUpdater
  pattr_initialize [:user!, :exercise!, :upcase_client!]

  def clone_created
    update_with('Started')
  end

  def revision_submitted
    update_with('Pushed')
  end

  def solution_submitted
    update_with('Submitted')
  end

  def comment_created(_comment)
    update_with('Reviewed')
  end

  private

  def update_with(state)
    upcase_client.update_status(exercise.uuid, state)
  end
end
