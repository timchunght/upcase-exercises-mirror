require 'spec_helper'

describe Gitolite::PublicKeysController do
  describe '#create' do
    it 'creates the key and updates Gitolite' do
      git_server = stub_service(:git_server)
      git_server.stub(:add_key)
      user = build_stubbed(:user)
      public_keys = stub_service(:current_public_keys)
      public_keys.stub(:create!)
      referer = '/some/path'

      sign_in_as user
      request.env['HTTP_REFERER'] = referer
      post :create, gitolite_public_key: { data: 'ssh-rsa 123' }

      expect(public_keys).to have_received(:create!).with(data: 'ssh-rsa 123')
      expect(git_server).to have_received(:add_key).with(user.username)
      expect(controller).to redirect_to(referer)
    end
  end
end
