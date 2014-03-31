# Exercises are for improving skills.
class Exercise < ActiveRecord::Base
  extend FriendlyId

  has_many :clones, dependent: :destroy
  has_many :solutions, through: :clones

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]

  def self.alphabetical
    order(:slug)
  end

  def find_or_create_clone_for(user)
    existing_clone_for(user) || create_clone_for(user)
  end

  def find_clone_for(user)
    existing_clone_for(user) || raise(ActiveRecord::RecordNotFound)
  end

  def find_or_create_solution_for(user)
    clone = find_clone_for(user)
    clone.solution || clone.create_solution!
  end

  def solved_by?(user)
    existing_clone_for(user).try(:solution).present?
  end

  def find_solution_for(user)
    find_clone_for(user).solution || raise(ActiveRecord::RecordNotFound)
  end

  private

  def existing_clone_for(user)
    clones.find_by_user_id(user.id)
  end

  def create_clone_for(user)
    clones.create!(user: user).tap do
      GIT_SERVER.create_clone(self, user)
    end
  end
end
