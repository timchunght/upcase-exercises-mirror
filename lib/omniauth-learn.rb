require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Learn < OmniAuth::Strategies::OAuth2
      option :name, 'learn'

      option :client_options, site: LEARN_URL, authorize_url: '/oauth/authorize'

      uid { raw_info['id'] }
      info { raw_info.except('id') }
      extra { { 'raw_info' => raw_info } }

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed['user']
      end
    end
  end
end
