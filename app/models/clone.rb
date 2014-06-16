# Each User working on an Exercise has their own clone.
class Clone < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  has_many :revisions, dependent: :destroy
  has_one :solution, dependent: :destroy

  validates! :parent_sha, format: /\A[a-z0-9]{40}\z/

  def title
    exercise.title
  end

  def username
    user.username
  end

  def create_revision!(attributes)
    revisions.create!(attributes.merge(solution: solution))
  end

  def create_solution!
    Solution.create!(clone: self).tap do |solution|
      revisions.latest.update_attributes!(solution: solution)
    end
  end
end
