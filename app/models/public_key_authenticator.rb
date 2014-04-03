# Syncronizes a User's public keys with the local PublicKey model when they
# sign in.
class PublicKeyAuthenticator
  pattr_initialize :authenticator, :auth_hash, :syncronizer_factory

  def authenticate
    authenticator.authenticate.tap do |user|
      syncronizer_factory.new(
        user: user,
        local_keys: user.public_keys,
        remote_keys: remote_keys
      ).syncronize
    end
  end

  private

  def remote_keys
    auth_hash['info']['public_keys']
  end
end
