# Created when a user wants a review of their clone of an exercise.
class Solution < ActiveRecord::Base
  belongs_to :clone

  validates :clone, presence: true

  def user
    clone.user
  end

  def exercise
    clone.exercise
  end

  def to_param
    user.to_param
  end
end
