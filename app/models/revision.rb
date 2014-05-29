class Revision < ActiveRecord::Base
  belongs_to :solution
  has_many :inline_comments, dependent: :destroy
  has_one :exercise, through: :solution
  has_one :user, through: :solution
end
