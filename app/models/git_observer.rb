# Notifies the GitServer when git-related events occur during user
# participation in exercises.
class GitObserver
  pattr_initialize :git_server

  def clone_created(clone)
    clone.update_attributes!(
      parent_sha: git_server.create_clone(clone.exercise, clone.user)
    )
  end

  def solution_created(solution)
    solution.create_snapshot!
      .update_attributes!(
        diff: git_server.create_diff(solution, solution.clone)
      )
  end
end
