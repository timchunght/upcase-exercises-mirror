class Comment < ActiveRecord::Base
  belongs_to :solution
  belongs_to :user

  validates :text, presence: true
end
