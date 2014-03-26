require 'spec_helper'

describe User do
  it { should have_many(:clones).dependent(:destroy) }
  it { should have_many(:public_keys).dependent(:destroy) }

  describe '.admin_usernames' do
    it 'returns usernames for admins alphabetically' do
      create :admin, username: 'def'
      create :admin, username: 'abc'
      create :admin, username: 'ghi'
      create :user, admin: false, username: 'unexpected'

      result = User.admin_usernames

      expect(result).to eq(%w(abc def ghi))
    end
  end

  describe '.by_username' do
    it 'orders users by username' do
      create :user, username: 'def'
      create :user, username: 'abc'
      create :user, username: 'ghi'

      result = User.by_username.pluck(:username)

      expect(result).to eq(%w(abc def ghi))
    end
  end

  describe '#valid?' do
    it { should_not validate_presence_of(:password) }
  end
end
