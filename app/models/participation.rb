# Determine's a User's current state of participation in an exercise and
# provides methods for moving them through the workflow.
class Participation
  pattr_initialize [:exercise, :user, :git_server, :clones]

  def create_clone
    git_server.create_clone(exercise, user)
  end

  def has_clone?
    existing_clone.present?
  end

  def find_clone
    existing_clone || raise(ActiveRecord::RecordNotFound)
  end

  def unpushed?
    !pushed?
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

  def push_to_clone
    if has_clone?
      git_server.fetch_diff(find_clone)
    end
  end

  private

  def existing_clone
    clones.for_user(user)
  end

  def create_solution
    find_clone.create_solution!
  end

  def pushed?
    has_clone? && find_clone.revisions.any?
  end
end
