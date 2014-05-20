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

  def create_revision!(attributes)
    revisions.create!(attributes)
  end

  def latest_revision
    revisions.order(created_at: :desc).first
  end
end
