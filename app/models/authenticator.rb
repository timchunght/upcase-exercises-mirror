# Uses an omniauth hash to find or create a user from Learn.
class Authenticator
  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def authenticate
    User.find_or_initialize_by(learn_uid: uid).tap do |user|
      user.update_attributes!(
        admin: info['admin'],
        auth_token: auth_hash['credentials']['token'],
        email: info['email'],
        first_name: info['first_name'],
        last_name: info['last_name'],
        subscriber: info['has_active_subscription'],
        username: info['username']
      )
    end
  end

  private

  def uid
    auth_hash['uid'].to_s
  end

  def info
    auth_hash['info']
  end

  attr_reader :auth_hash
end
