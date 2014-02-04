class User < ActiveRecord::Base
  include Clearance::User

  def self.find_or_create_from_auth_hash(auth_hash)
    User.find_or_initialize_by(learn_uid: auth_hash['uid'].to_s).tap do |user|
      user.update_attributes!(
        auth_token: auth_hash['credentials']['token'],
        email: auth_hash['info']['email'],
        first_name: auth_hash['info']['first_name'],
        last_name: auth_hash['info']['last_name'],
        learn_uid: auth_hash['uid'],
        subscriber: auth_hash['info']['has_active_subscription']
      )
    end
  end

  private

  def password_optional?
    true
  end
end
