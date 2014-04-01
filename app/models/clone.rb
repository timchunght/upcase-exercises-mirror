# Each User working on an Exercise has their own clone.
class Clone < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  has_one :solution, dependent: :destroy

  def title
    exercise.title
  end
end
