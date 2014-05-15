LEARN_CLIENT_ID = ENV['LEARN_CLIENT_ID']
LEARN_CLIENT_SECRET = ENV['LEARN_CLIENT_SECRET']
LEARN_URL = ENV['LEARN_URL']

require 'omniauth-learn'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :learn,
    LEARN_CLIENT_ID,
    LEARN_CLIENT_SECRET
  )
end

OmniAuth.config.logger = Rails.logger
