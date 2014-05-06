# Exercises are for improving skills.
class Exercise < ActiveRecord::Base
  extend FriendlyId

  has_many :clones, dependent: :destroy
  has_many :solutions, through: :clones
  has_many :solvers, source: :user, through: :clones

  validates :instructions, presence: true
  validates :intro, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]

  def self.alphabetical
    order(:slug)
  end

  def has_solutions?
    solutions.any?
  end
end
