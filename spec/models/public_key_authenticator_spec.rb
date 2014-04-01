require 'spec_helper'

describe PublicKeyAuthenticator do
  describe '#authenticate' do
    it 'syncronizes remote keys' do
      remote_keys = %w(key-one key-two)
      local_keys = double('user.public_keys')
      user = double('user', public_keys: local_keys)
      syncronizer = double('syncronizer')
      syncronizer.stub(:syncronize)
      syncronizer_factory = double('syncronizer_factory')
      syncronizer_factory
        .stub(:new)
        .with(user: user, local_keys: local_keys, remote_keys: remote_keys)
        .and_return(syncronizer)
      authenticator = double('authenticator', authenticate: user)
      auth_hash = {
        'info' => {
          'public_keys' => remote_keys
        }
      }

      result = PublicKeyAuthenticator.new(
        authenticator,
        auth_hash,
        syncronizer_factory
      ).authenticate

      expect(result).to eq(user)
      expect(syncronizer).to have_received(:syncronize)
    end
  end
end
