class InlineComment < ActiveRecord::Base
  belongs_to :revision
  belongs_to :user

  def self.chronological
    order(created_at: :asc)
  end
end
