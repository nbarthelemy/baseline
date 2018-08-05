module Api
  class ApplicationController < ActionController::API
    include ActionController::Helpers
    include ActionController::HttpAuthentication::Token::ControllerMethods

    include Api::TokenThrottleable
    include Api::TokenAuthenticatable

  end
end