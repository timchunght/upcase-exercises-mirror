require 'spec_helper'

describe PublicKeySyncronizer do
  describe '#syncronize' do
    it 'adds new keys' do
      remote_keys = %w(key-one key-two)
      local_keys = double('user.public_keys')
      local_keys.stub(:find_or_create_by!)

      PublicKeySyncronizer.new(local_keys, remote_keys).syncronize

      remote_keys.each do |key|
        expect(local_keys).to have_received(:find_or_create_by!).with(data: key)
      end
    end
  end
end
