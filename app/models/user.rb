class User < ActiveRecord::Base
  include Clearance::User

  def self.find_or_create_from_auth_hash(auth_hash)
    User.find_or_initialize_by(learn_uid: auth_hash['uid'].to_s).tap do |user|
      user.update_attributes!(
        email: auth_hash['info']['email'],
        first_name: auth_hash['info']['first_name'],
        last_name: auth_hash['info']['last_name'],
        learn_uid: auth_hash['uid'],
        auth_token: auth_hash['credentials']['token']
      )
    end
  end

  private

  def password_optional?
    true
  end
end
