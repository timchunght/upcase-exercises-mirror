require 'spec_helper'

describe Gitolite::PublicKeySyncronizer do
  describe '#syncronize' do
    it 'adds new keys' do
      remote_keys = %w(new-one new-two existing)
      user = double('user', username: 'example')
      local_keys = stub_local_keys(%w(new-one new-two))
      server = double('server')
      server.stub(:add_key)

      Gitolite::PublicKeySyncronizer.new(
        server: server,
        local_keys: local_keys,
        remote_keys: remote_keys,
        user: user
      ).syncronize

      %w(new-one new-two).each do |key|
        expect(local_keys).to have_received(:create!).with(data: key)
      end

      expect(server).to have_received(:add_key).with(user.username).twice
      expect(local_keys).not_to have_received(:create!).with(data: 'existing')
    end

    def stub_local_keys(existing_keys)
      double('local_keys').tap do |keys|
        keys.stub(:create!)
        keys.stub(:exists?).and_return(true)
        existing_keys.each do |existing_key|
          keys.stub(:exists?).with(data: existing_key).and_return(false)
        end
      end
    end
  end
end
