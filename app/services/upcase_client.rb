class UpcaseClient
  pattr_initialize :oauth_upcase_client

  def update_status(user, exercise_uuid, state)
    access_token = OAuth2::AccessToken.new(oauth_upcase_client, user.auth_token)
    access_token.post(
      "/api/v1/exercises/#{exercise_uuid}/status",
      params: { state: state }
    )
  rescue *HTTP_ERRORS, OAuth2::Error => exception
    Airbrake.notify(exception)
  end
end
