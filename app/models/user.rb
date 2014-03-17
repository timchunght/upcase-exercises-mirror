class User < ActiveRecord::Base
  include Clearance::User

  has_many :public_keys, dependent: :destroy

  private

  def password_optional?
    true
  end
end
