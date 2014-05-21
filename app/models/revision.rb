class Revision < ActiveRecord::Base
  belongs_to :solution
  has_many :inline_comments, dependent: :destroy

  def comments_for(file_name, line_number)
    inline_comments.where(file_name: file_name, line_number: line_number)
  end
end
