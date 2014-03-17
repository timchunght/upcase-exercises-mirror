class OauthCallbacksController < ApplicationController
  skip_before_filter :authorize

  def show
    @user = authenticate
    if @user.subscriber?
      sign_in @user
      redirect_back_or default_after_auth_url
    else
      redirect_to 'https://learn.thoughtbot.com/prime'
    end
  end

  private

  def authenticate
    PublicKeySyncronizer.new(
      Authenticator.new(auth_hash),
      auth_hash
    ).authenticate
  end

  def default_after_auth_url
    if @user.admin?
      admin_root_url
    else
      root_url
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
