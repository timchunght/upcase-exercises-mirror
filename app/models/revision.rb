class Revision < ActiveRecord::Base
  belongs_to :clone
  belongs_to :solution
  has_one :exercise, through: :solution
  has_one :user, through: :solution

  validates :diff, presence: true

  def self.latest
    order(created_at: :desc).first
  end
end
