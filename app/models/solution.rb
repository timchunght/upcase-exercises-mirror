# Created when a user wants a review of their clone of an exercise.
class Solution < ActiveRecord::Base
  belongs_to :clone
  has_one :revision, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :clone, presence: true

  def diff
    revision.diff
  end

  def user
    clone.user
  end

  def exercise
    clone.exercise
  end
end
