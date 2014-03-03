class OauthCallbacksController < ApplicationController
  skip_before_filter :authorize

  def show
    @user = User.find_or_create_from_auth_hash(auth_hash)
    if @user.subscriber?
      sign_in @user
      redirect_back_or default_after_auth_url
    else
      redirect_to 'https://learn.thoughtbot.com/prime'
    end
  end

  private

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
