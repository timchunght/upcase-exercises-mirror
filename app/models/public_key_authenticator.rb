# Syncronizes a User's public keys with the local PublicKey model when they
# sign in.
class PublicKeyAuthenticator
  def initialize(authenticator, auth_hash)
    @authenticator = authenticator
    @auth_hash = auth_hash
  end

  def authenticate
    @authenticator.authenticate.tap do |user|
      PublicKeySyncronizer.new(user.public_keys, remote_keys).syncronize
    end
  end

  private

  def remote_keys
    @auth_hash['info']['public_keys']
  end
end
