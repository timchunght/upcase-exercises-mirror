# Created when a user wants a review of their clone of an exercise.
class Solution < ActiveRecord::Base
  belongs_to :clone
  has_many :comments, dependent: :destroy
  has_many :revisions, dependent: :destroy

  validates :clone, presence: true

  def diff
    latest_revision.diff
  end

  def user
    clone.user
  end

  def exercise
    clone.exercise
  end

  def create_revision!(attributes)
    revisions.create!(attributes)
  end

  def latest_revision
    revisions.order(created_at: :desc).first
  end

  def latest_comments_for(file_name, line_number)
    latest_revision.comments_for(file_name, line_number)
  end
end
