class Comment < ActiveRecord::Base
  belongs_to :solution, counter_cache: true
  belongs_to :user

  validates :text, presence: true
end
