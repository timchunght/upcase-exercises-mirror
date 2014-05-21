class InlineComment < ActiveRecord::Base
  belongs_to :revision
  belongs_to :user
end
