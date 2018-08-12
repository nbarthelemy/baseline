require 'omniauth-oauth2'

# app_id = "631961173e1404e9d67999a13bc1d9e2389e7cd726a3f93f04803e57991b23ba"
# secret = "7a202f5f67bb7bb54c413016f103d20a254f0ef9f1ae70851b10949419200145"

# client = OAuth2::Client.new(app_id, secret, site: "http://api.baseline.test")
# access_token = client.password.get_token('nmb@siquora.com', 'password')
# puts access_token.token

module OmniAuth
  module Strategies
    class Doorkeeper
      include OmniAuth::Strategy

      # change the class name and the :name option to match your application name
      option :name, :doorkeeper
      option :client_options, {
        site: ENV['API_URL'],
        token_url: "/oauth/token",
        authorize_url: "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        raw_info.merge("token" => access_token.token)
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

    end
  end
end