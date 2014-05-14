require 'omniauth-oauth2'
require 'new_relic/agent/method_tracer'

module OmniAuth
  module Strategies
    class Learn < OmniAuth::Strategies::OAuth2
      include ::NewRelic::Agent::MethodTracer

      option :name, 'learn'

      option :client_options, site: LEARN_URL, authorize_url: '/oauth/authorize'

      uid { raw_info['id'] }
      info { raw_info.except('id') }
      extra { { 'raw_info' => raw_info } }

      def raw_info
        @raw_info ||= fetch_raw_info.parsed['user']
      end

      private

      def fetch_raw_info
        access_token.get('/api/v1/me.json')
      end

      add_method_tracer :fetch_raw_info
    end
  end
end
