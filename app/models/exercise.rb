class Exercise < ActiveRecord::Base
  extend FriendlyId

  has_many :clones, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]

  def find_or_create_clone_for(user)
    find_clone_for(user) || create_clone_for(user)
  end

  private

  def find_clone_for(user)
    clones.find_by_user_id(user.id)
  end

  def create_clone_for(user)
    clones.create!(user: user).tap do
      GIT_SERVER.create_clone(self, user)
    end
  end
end
