class User < ActiveRecord::Base
  include Clearance::User

  private

  def password_optional?
    true
  end
end
