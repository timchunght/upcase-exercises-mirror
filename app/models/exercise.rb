class Exercise < ActiveRecord::Base
  extend FriendlyId

  validates :body, presence: true
  validates :title, presence: true, uniqueness: true

  friendly_id :title, use: [:slugged, :finders]
end
