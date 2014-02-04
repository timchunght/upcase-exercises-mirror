require 'spec_helper'

describe OauthCallbacksController do
  describe '#show' do
    context 'with a subscriber' do
      it 'signs in' do
        user = stub_user_from_auth_hash
        user.stub(:subscriber?).and_return(true)

        request_callback

        should redirect_to(root_url)
        expect(controller.current_user).to eq(user)
      end
    end

    context 'with a non-subscriber' do
      it 'redirects without signing in' do
        user = stub_user_from_auth_hash
        user.stub(:subscriber?).and_return(false)

        request_callback

        should redirect_to('https://learn.thoughtbot.com/prime')
        should_not be_signed_in
      end
    end

    def request_callback
      get :show, provider: 'learn'
    end
  end

  def stub_user_from_auth_hash
    build_stubbed(:user).tap do |user|
      auth_hash = double('auth_hash')
      request.env['omniauth.auth'] = auth_hash
      User.stub(:find_or_create_from_auth_hash).with(auth_hash).and_return(user)
    end
  end
end
