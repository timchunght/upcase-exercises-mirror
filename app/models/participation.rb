# Determine's a User's current state of participation in an exercise and
# provides methods for moving them through the workflow.
class Participation
  pattr_initialize :exercise, :user, :observer

  def find_or_create_clone
    existing_clone || create_clone
  end

  def find_clone
    existing_clone || raise(ActiveRecord::RecordNotFound)
  end

  def find_or_create_solution
    find_clone.solution || find_clone.create_solution!
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
    clones.create!(user: user).tap do |clone|
      observer.clone_created(clone)
    end
  end

  def clones
    exercise.clones
  end
end
