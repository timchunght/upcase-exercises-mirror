class OauthCallbacksController < ApplicationController
  skip_before_filter :authorize

  def show
    @user = User.find_or_create_from_auth_hash(auth_hash)
    sign_in @user
    redirect_to root_url
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
