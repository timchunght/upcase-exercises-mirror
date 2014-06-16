# Created when a user wants a review of their clone of an exercise.
class Solution < ActiveRecord::Base
  belongs_to :clone
  has_many :comments, dependent: :destroy
  has_many :revisions, dependent: :destroy
  has_one :exercise, through: :clone
  has_one :user, through: :clone

  validates :clone, presence: true

  def diff
    latest_revision.diff
  end

  def username
    clone.username
  end

  def has_comments?
    comments.present?
  end

  def latest_revision
    revisions.latest
  end
end
