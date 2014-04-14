# Decorates a Clone to add Git-specific functionality.
class GitClone < SimpleDelegator
  def initialize(clone, git_server)
    super(clone)
    @clone = clone
    @git_server = git_server
  end

  def repository
    @git_server.find_clone(@clone.exercise, @clone.user)
  end
end
