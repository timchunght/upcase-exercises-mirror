class User < ActiveRecord::Base
  include Clearance::User

  has_many :clones, dependent: :destroy
  has_many :public_keys, dependent: :destroy

  def self.admin_usernames
    admins.by_username.usernames
  end

  def self.by_username
    order(:username)
  end

  private

  def self.admins
    where(admin: true)
  end

  def self.usernames
    pluck(:username)
  end

  def password_optional?
    true
  end
end
