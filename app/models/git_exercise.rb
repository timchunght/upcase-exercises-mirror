# Decorates an Exercise to add Git-specific functionality.
class GitExercise < SimpleDelegator
  def initialize(exercise, git_server)
    super(exercise)
    @exercise = exercise
    @git_server = git_server
  end

  def source
    @git_server.find_source(@exercise)
  end
end
