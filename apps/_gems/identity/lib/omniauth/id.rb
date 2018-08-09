require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Id < OmniAuth::Strategies::OAuth2

      def self.endpoint
        if ENV['OMNIAUTH_SSO_ENDPOINT'].to_s != ''
          ENV['OMNIAUTH_SSO_ENDPOINT'].to_s
        elsif Rails.env.development? || Rails.env.test?
          'http://id.baseline.test'
        else
          fail 'You must set OMNIAUTH_SSO_ENDPOINT to point to the SSO OAuth server'
        end
      end

      option :name, :id
      option :client_options, site: endpoint, authorize_url: "/oauth/authorize"

      uid { raw_info["id"] }

      info do
        {
          email: raw_info["email"],
          name: raw_info["name"]
        }
      end

      extra do
        skip_info? ? {} : { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end

    end
  end
end