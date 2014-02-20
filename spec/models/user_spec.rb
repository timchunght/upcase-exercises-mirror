require 'spec_helper'

describe User do
  describe '#valid?' do
    it { should_not validate_presence_of(:password) }
  end

  describe '.find_or_create_from_auth_hash' do
    context 'with an existing user' do
      it 'finds that user' do
        existing_user = create(:user, learn_uid: 1)
        auth_hash = build_auth_hash('uid' => 1)

        user = User.find_or_create_from_auth_hash(auth_hash)

        expect(user).to eq(existing_user)
      end
    end

    context 'without an existing user' do
      it 'creates a new user' do
        auth_hash = build_auth_hash

        user = User.find_or_create_from_auth_hash(auth_hash)

        expect(user).to be_persisted
        expect(user.email).to eq(auth_hash['info']['email'])
        expect(user.first_name).to eq(auth_hash['info']['first_name'])
        expect(user.last_name).to eq(auth_hash['info']['last_name'])
        expect(user.learn_uid).to eq(auth_hash['uid'])
        expect(user.auth_token).to eq(auth_hash['credentials']['token'])
        expect(user.admin).to eq(auth_hash['info']['admin'])
        expect(user.subscriber?).
          to eq(auth_hash['info']['has_active_subscription'])
      end
    end

    def build_auth_hash(overrides = {})
      {
        'credentials' => {
          'token' => 'abc123'
        },
        'info' => {
          'admin' => true,
          'email' => 'user@example.com',
          'first_name' => 'Test',
          'has_active_subscription' => true,
          'last_name' => 'User'
        },
        'provider' => 'learn',
        'uid' => 1
      }.merge(overrides)
    end
  end
end
