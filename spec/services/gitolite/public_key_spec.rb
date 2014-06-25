require 'spec_helper'

describe Gitolite::PublicKey do
  it { should validate_presence_of(:data) }
  it { should validate_presence_of(:user_id) }

  it 'checks the fingerprint' do
    key = Gitolite::PublicKey.new(fingerprint: nil)

    expect(key).not_to be_valid
    expect(key.errors.full_messages).
      to include('Data did not contain a valid SSH public key')
  end
end
