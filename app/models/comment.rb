class Comment < ActiveRecord::Base
  belongs_to :solution, counter_cache: true
  belongs_to :user

  validates :text, presence: true

  def solution_submitter
    solution.user
  end

  def exercise
    solution.exercise
  end
end
