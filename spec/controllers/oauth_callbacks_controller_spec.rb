require 'spec_helper'

describe OauthCallbacksController do
  describe '#show' do
    context "with a return to URL" do
      it 'returns to the return to URL' do
        session[:return_to] = 'http://otherhost.com/return_to'
        user = stub_user_from_auth_hash
        user.stub(:admin?).and_return(false)
        user.stub(:subscriber?).and_return(true)

        request_callback

        should redirect_to('/return_to')
      end
    end

    context 'with a non-admin subscriber' do
      it 'signs in' do
        user = stub_user_from_auth_hash
        user.stub(:subscriber?).and_return(true)
        user.stub(:admin?).and_return(false)

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

    context "with an admin subscriber" do
      it 'redirects to the admin dashboard' do
        user = stub_user_from_auth_hash
        user.stub(:admin?).and_return(true)
        user.stub(:subscriber?).and_return(true)

        request_callback

        should redirect_to(admin_root_url)
      end
    end

    def request_callback
      get :show, provider: 'learn'
    end
  end

  def stub_user_from_auth_hash
    build_stubbed(:user).tap do |user|
      auth_hash = double('auth_hash')
      authenticator = double('authenticator', authenticate: user)
      Authenticator.stub(:new).and_return(authenticator)
      request.env['omniauth.auth'] = auth_hash
    end
  end
end
