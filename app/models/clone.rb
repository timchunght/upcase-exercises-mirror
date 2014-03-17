class Clone < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise

  def repository
    GIT_SERVER.clone(exercise, user)
  end

  def title
    exercise.title
  end
end
