class OauthCallbacksController < ApplicationController
  skip_before_filter :authorize

  def show
    @user = User.find_or_create_from_auth_hash(auth_hash)
    if @user.subscriber?
      sign_in @user
      redirect_to root_url
    else
      redirect_to 'https://learn.thoughtbot.com/prime'
    end
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
