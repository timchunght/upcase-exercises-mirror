class InlineComment < ActiveRecord::Base
  belongs_to :revision
  belongs_to :user

  def self.chronological
    order(created_at: :asc)
  end

  def solution_submitter
    revision.user
  end

  def exercise
    revision.exercise
  end
end
