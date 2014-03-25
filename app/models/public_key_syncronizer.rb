# Syncronizes a User's public keys with the local PublicKey model when they
# sign in.
class PublicKeySyncronizer
  def initialize(authenticator, auth_hash)
    @authenticator = authenticator
    @auth_hash = auth_hash
  end

  def authenticate
    @authenticator.authenticate.tap do |user|
      syncronize_public_keys_for user
    end
  end

  private

  def syncronize_public_keys_for(user)
    public_keys.each do |public_key|
      user.public_keys.find_or_create_by!(data: public_key)
    end
  end

  def public_keys
    @auth_hash['info']['public_keys']
  end
end
