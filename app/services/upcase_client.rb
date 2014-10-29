class UpcaseClient
  pattr_initialize :oauth_upcase_client

  def update_status(user, exercise_uuid, state)
    rescue_common_errors do
      access_token = OAuth2::AccessToken.new(oauth_upcase_client, user.auth_token)
      access_token.post(
        "/api/v1/exercises/#{exercise_uuid}/status",
        params: { state: state }
      )
    end
  end

  def synchronize_exercise(exercise_attributes)
    rescue_common_errors do
      uuid = exercise_attributes[:uuid]
      access_token = oauth_upcase_client.client_credentials.get_token
      access_token.put(
        "/api/v1/exercises/#{uuid}",
        params: { exercise: exercise_attributes.except(:uuid) }
      )
    end
  end

  private

  def rescue_common_errors
    yield
  rescue *HTTP_ERRORS, OAuth2::Error => exception
    error_notifier.notify(exception)
  end
end
