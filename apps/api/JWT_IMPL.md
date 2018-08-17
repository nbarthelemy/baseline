module Api
  class ApplicationController < ActionController::API
    # include ActionController::HttpAuthentication::Token::ControllerMethods
    include ActionController::RequestForgeryProtection

    # include Api::TokenThrottleable
    # include Api::TokenAuthenticatable

    before_action :doorkeeper_authorize!

    respond_to :json

  protected

    def current_resource_owner
      @current_resource_owner ||= if doorkeeper_token
        Api::User.find(doorkeeper_token.resource_owner_id)
      end
    end
    alias :current_user :current_resource_owner

    def jwt_session_data
      Doorkeeper::JWT.decode(token)
    end

  private

    def token
      request.headers['authorization'].split(/\s+/).last
    end

  end
end

module Api
  class User < ::Core::User

    # May also include :destroy if you need callbacks
    has_many :access_grants, class_name: "Doorkeeper::AccessGrant",
      foreign_key: :resource_owner_id, dependent: :delete_all

    # May also include :destroy if you need callbacks
    has_many :access_tokens, class_name: "Doorkeeper::AccessToken",
      foreign_key: :resource_owner_id, dependent: :delete_all


    def jwt_session_hash
      { id: id, email: email }
    end

  end
end

require 'doorkeeper'
require 'doorkeeper-jwt'
require 'devise'
require 'devise/doorkeeper'

# Configure devise for use with Doorkeeper
Devise::Doorkeeper.configure_devise(Devise)

# configure Doorkeeper
Doorkeeper.configure do
  Devise::Doorkeeper.configure_doorkeeper(self)

  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    fail "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
    # Put your resource owner authentication logic here.
    # Example implementation:
    #   User.find_by_id(session[:user_id]) || redirect_to(new_user_session_url)
  end

  # In this flow, a token is requested in exchange for the resource owner credentials (username and password)
  resource_owner_from_credentials do |routes|
    user = Api::User.find_for_database_authentication(email: params[:username])
    if user && user.valid_for_authentication? { user.valid_password?(params[:password]) }
      user
    end
  end

  # If you want to restrict access to the web interface for adding oauth authorized applications, you need to declare the block below.
  # admin_authenticator do
  #   # Put your admin authentication logic here.
  #   # Example implementation:
  #   Admin.find_by_id(session[:admin_id]) || redirect_to(new_admin_session_url)
  # end

  # Authorization Code expiration time (default 10 minutes).
  # authorization_code_expires_in 10.minutes

  # Access token expiration time (default 2 hours).
  # If you want to disable expiration, set this to nil.
  # access_token_expires_in 2.hours
  access_token_expires_in 2.hours

  # Assign a custom TTL for implicit grants.
  # custom_access_token_expires_in do |oauth_client|
  #   oauth_client.application.additional_settings.implicit_oauth_expiration
  # end

  # Use a custom class for generating the access token.
  # https://github.com/doorkeeper-gem/doorkeeper#custom-access-token-generator
  # access_token_generator '::Doorkeeper::JWT'

  # The controller Doorkeeper::ApplicationController inherits from.
  # Defaults to ActionController::Base.
  # https://github.com/doorkeeper-gem/doorkeeper#custom-base-controller
  base_controller 'Api::ApplicationController'

  # Reuse access token for the same resource owner within an application (disabled by default)
  # Rationale: https://github.com/doorkeeper-gem/doorkeeper/issues/383
  # reuse_access_token
  reuse_access_token

  # Issue access tokens with refresh token (disabled by default)
  # use_refresh_token

  # Provide support for an owner to be assigned to each registered application (disabled by default)
  # Optional parameter confirmation: true (default false) if you want to enforce ownership of
  # a registered application
  # Note: you must also run the rails g doorkeeper:application_owner generator to provide the necessary support
  # enable_application_owner confirmation: false

  # Define access token scopes for your provider
  # For more information go to
  # https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-Scopes
  # default_scopes  :public
  # optional_scopes :write, :update
  default_scopes  :public
  optional_scopes :write, :update

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:client_id` and `:client_secret` params from the `params` object.
  # Check out https://github.com/doorkeeper-gem/doorkeeper/wiki/Changing-how-clients-are-authenticated
  # for more information on customization
  # client_credentials :from_basic, :from_params

  # Change the way access token is authenticated from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:access_token` or `:bearer_token` params from the `params` object.
  # Check out https://github.com/doorkeeper-gem/doorkeeper/wiki/Changing-how-clients-are-authenticated
  # for more information on customization
  # access_token_methods :from_bearer_authorization, :from_access_token_param, :from_bearer_param

  # Change the native redirect uri for client apps
  # When clients register with the following redirect uri, they won't be redirected to any server and the authorization code will be displayed within the provider
  # The value can be any string. Use nil to disable this feature. When disabled, clients must provide a valid URL
  # (Similar behaviour: https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
  #
  # native_redirect_uri 'urn:ietf:wg:oauth:2.0:oob'

  # Forces the usage of the HTTPS protocol in non-native redirect uris (enabled
  # by default in non-development environments). OAuth2 delegates security in
  # communication to the HTTPS protocol so it is wise to keep this enabled.
  #
  # Callable objects such as proc, lambda, block or any object that responds to
  # #call can be used in order to allow conditional checks (to allow non-SSL
  # redirects to localhost for example).
  #
  # force_ssl_in_redirect_uri !Rails.env.development?
  #
  # force_ssl_in_redirect_uri { |uri| uri.host != 'localhost' }

  # Specify what redirect URI's you want to block during creation. Any redirect
  # URI is whitelisted by default.
  #
  # You can use this option in order to forbid URI's with 'javascript' scheme
  # for example.
  #
  # forbid_redirect_uri { |uri| uri.scheme.to_s.downcase == 'javascript' }

  # Specify what grant flows are enabled in array of Strings. The valid
  # strings and the flows they enable are:
  #
  # "authorization_code" => Authorization Code Grant Flow
  # "implicit"           => Implicit Grant Flow
  # "password"           => Resource Owner Password Credentials Grant Flow
  # "client_credentials" => Client Credentials Grant Flow
  #
  # If not specified, Doorkeeper enables authorization_code and
  # client_credentials.
  #
  # implicit and password grant flows have risks that you should understand
  # before enabling:
  #   http://tools.ietf.org/html/rfc6819#section-4.4.2
  #   http://tools.ietf.org/html/rfc6819#section-4.4.3
  #
  # grant_flows %w[authorization_code client_credentials]

  grant_flows %w[authorization_code client_credentials password]

  # Hook into the strategies' request & response life-cycle in case your
  # application needs advanced customization or logging:
  #
  # before_successful_strategy_response do |request|
  #   puts "BEFORE HOOK FIRED! #{request}"
  # end
  #
  # after_successful_strategy_response do |request, response|
  #   puts "AFTER HOOK FIRED! #{request}, #{response}"
  # end

  # Under some circumstances you might want to have applications auto-approved,
  # so that the user skips the authorization step.
  # For example if dealing with a trusted application.
  # skip_authorization do |resource_owner, client|
  #   client.superapp? or resource_owner.admin?
  # end

  skip_authorization do |resource_owner, client|
    true
  end

  # WWW-Authenticate Realm (default "Doorkeeper").
  # realm "Doorkeeper"
end

Doorkeeper::JWT.configure do
  # Set the payload for the JWT token. This should contain unique information
  # about the user.
  # Defaults to a randomly generated token in a hash
  # { token: "RANDOM-TOKEN" }
  #
  # Additional references to prevent
  # ```
  #   422 error
  #
  #   ActiveRecord::RecordInvalid (Validation failed: Token has already been taken):
  # ```
  #
  #  https://stackoverflow.com/questions/31193369/repetitive-authorization-gives-error-422-with-doorkeeper-resource-owner-credent
  token_payload do |opts|
    user = Api::User.find(opts[:resource_owner_id])
    {
      iss: Rails.application.class.parent.to_s.underscore,
      iat: Time.now.utc.to_i,
      jti: SecureRandom.uuid,

      user: user.jwt_session_hash
    }
  end

  # Optionally set additional headers for the JWT. See https://tools.ietf.org/html/rfc7515#section-4.1
  # token_headers do |opts|
  #   {
  #     kid: opts[:application][:uid]
  #   }
  # end

  # Use the application secret specified in the Access Grant token
  # Defaults to false
  # If you specify `use_application_secret true`, both secret_key and secret_key_path will be ignored
  use_application_secret false

  # Set the encryption secret. This would be shared with any other applications
  # that should be able to read the payload of the token.
  # Defaults to "secret"
  # secret_key ENV["JWT_ENCRYPTION_SECRET"]

  # If you want to use RS* encoding specify the path to the RSA key
  # to use for signing.
  # If you specify a secret_key_path it will be used instead of secret_key
  # secret_key_path "path/to/file.pem"

  # Specify encryption type. Supports any algorithm in
  # https://github.com/progrium/ruby-jwt
  # defaults to nil
  encryption_method :hs512
end

# add a decode method to doorkeeper-jwt
module Doorkeeper
  module JWT
    class << self
      def decode(token)
        key = secret_key({})
        ::JWT.decode(token, key, !key.nil?, { algorithm: encryption_method })
      end
    end
  end
end

$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api"
  s.version     = Api::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Api."
  s.description = "Description of Api."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # A lightning fast JSON:API serializer. See https://github.com/Netflix/fast_jsonapi
  s.add_dependency "fast_jsonapi"

  # OAuth 2 provider
  s.add_dependency 'doorkeeper'

  # JWT token provider ( acts as a session in a stateless api )
  s.add_dependency 'doorkeeper-jwt'

  # glue code for devise and doorkeeper ( core requires devise )
  s.add_dependency 'devise-doorkeeper'

  # Cross-Origin Resource Sharing (CORS); Makes cross-origin AJAX possible.
  s.add_dependency "rack-cors"

  # Blocking & throttling See: https://github.com/kickstarter/rack-attack
  s.add_dependency "rack-attack"

  # Use Redis adapter for caching and throttling
  s.add_dependency 'redis', '~> 4.0'

  # Documentation. See: https://github.com/kickstarter/rack-attack
  s.add_dependency "swagger-docs"

  #### Shared Engine Gems ####

  s.add_dependency "core"

end
