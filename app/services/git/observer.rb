module Git
  # Notifies the Git server when git-related events occur during user
  # participation in exercises. See Gitolite::Server.
  class Observer
    pattr_initialize :server

    def clone_created(clone)
      clone.update_attributes!(
        parent_sha: server.create_clone(clone.exercise, clone.user)
      )
    end

    def solution_created(solution)
      solution.create_snapshot!
        .update_attributes!(
          diff: server.create_diff(solution, solution.clone)
        )
    end
  end
end
