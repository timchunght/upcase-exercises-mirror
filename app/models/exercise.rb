# Exercises are for improving skills.
class Exercise < ActiveRecord::Base
  extend FriendlyId

  has_many :clones, dependent: :destroy
  has_many :solutions, through: :clones

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]

  def self.alphabetical
    order(:slug)
  end
end
