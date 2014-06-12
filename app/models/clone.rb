# Each User working on an Exercise has their own clone.
class Clone < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  has_one :solution, dependent: :destroy

  validates! :parent_sha, format: /\A[a-z0-9]{40}\z/

  def title
    exercise.title
  end

  def username
    user.username
  end

  def create_revision!(attributes)
    solution.create_revision!(attributes)
  end
end
