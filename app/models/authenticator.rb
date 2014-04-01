# Uses an omniauth hash to find or create a user from Learn.
class Authenticator
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def authenticate
    find_or_initialize_user.tap do |user|
      user.update_attributes!(user_attributes)
    end
  end

  private

  def find_or_initialize_user
    User.find_or_initialize_by(learn_uid: uid)
  end

  def user_attributes
    {
      admin: info['admin'],
      auth_token: auth_hash['credentials']['token'],
      avatar_url: info['avatar_url'],
      email: info['email'],
      first_name: info['first_name'],
      last_name: info['last_name'],
      subscriber: info['has_active_subscription'],
      username: info['username']
    }
  end

  def uid
    auth_hash['uid'].to_s
  end

  def info
    auth_hash['info']
  end

  attr_reader :auth_hash
end
