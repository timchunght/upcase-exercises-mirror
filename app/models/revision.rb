class Revision < ActiveRecord::Base
  belongs_to :solution
  has_many :inline_comments, dependent: :destroy
end
