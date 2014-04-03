# Notifies the GitServer when git-related events occur during user
# participation in exercises.
class GitObserver
  pattr_initialize :git_server

  def clone_created(clone)
    git_server.create_clone(clone.exercise, clone.user)
  end
end
