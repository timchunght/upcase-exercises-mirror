class User < ActiveRecord::Base
  include Clearance::User

  has_many :clones, dependent: :destroy
  has_many :public_keys, dependent: :destroy

  def self.by_username
    order(:username)
  end

  private

  def password_optional?
    true
  end
end
