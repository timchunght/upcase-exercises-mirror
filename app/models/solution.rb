# Created when a user wants a review of their clone of an exercise.
class Solution < ActiveRecord::Base
  belongs_to :clone
  has_one :snapshot, dependent: :destroy

  validates :clone, presence: true

  def diff
    snapshot.diff
  end

  def user
    clone.user
  end

  def exercise
    clone.exercise
  end
end
