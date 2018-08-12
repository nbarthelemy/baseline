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

  end
end