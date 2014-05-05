# Determine's a User's current state of participation in an exercise and
# provides methods for moving them through the workflow.
class Participation
  pattr_initialize [:exercise, :user, :git_server]

  def find_or_create_clone
    existing_clone || create_clone
  end

  def find_clone
    existing_clone || raise(ActiveRecord::RecordNotFound)
  end

  def find_or_create_solution
    find_clone.solution || create_solution
  end

  def has_solution?
    existing_clone.try(:solution).present?
  end

  def find_solution
    find_clone.solution || raise(ActiveRecord::RecordNotFound)
  end

  private

  def existing_clone
    clones.find_by_user_id(user.id)
  end

  def create_clone
    sha = git_server.create_clone(exercise, user)
    clones.create!(user: user, parent_sha: sha)
  end

  def create_solution
    clone = find_clone
    clone.create_solution!.tap do |solution|
      diff = git_server.create_diff(solution, clone)
      solution.create_snapshot!(diff: diff)
    end
  end

  def clones
    exercise.clones
  end
end
