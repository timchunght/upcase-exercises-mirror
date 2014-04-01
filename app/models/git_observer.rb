# Notifies the GitServer when git-related events occur during user
# participation in exercises.
class GitObserver
  def initialize(git_server)
    @git_server = git_server
  end

  def clone_created(clone)
    git_server.create_clone(clone.exercise, clone.user)
  end

  private

  attr_reader :git_server
end
