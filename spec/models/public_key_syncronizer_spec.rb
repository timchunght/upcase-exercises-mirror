require 'spec_helper'

describe PublicKeySyncronizer do
  describe '#authenticate' do
    it 'adds new keys' do
      public_keys = %w(key-one key-two)
      user_keys = double('user.public_keys')
      user_keys.stub(:find_or_create_by!)
      user = double('user', public_keys: user_keys)
      authenticator = double('authenticator', authenticate: user)
      auth_hash = {
        'info' => {
          'public_keys' => public_keys
        }
      }

      result = PublicKeySyncronizer.new(authenticator, auth_hash).authenticate

      public_keys.each do |key|
        expect(user.public_keys)
          .to have_received(:find_or_create_by!).with(data: key)
      end

      expect(result).to eq(user)
    end
  end
end
