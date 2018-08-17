require 'doorkeeper'
require 'devise'
require 'devise/doorkeeper'
require 'rack/cors'
require 'fast_jsonapi'
require 'swagger/docs'
require 'core'

module Api
  Doorkeeper = ::Doorkeeper

  class Engine < ::Rails::Engine
    engine_name :api

    initializer "Load rate limiting middleware" do |app|
      # Use middlware for rate limiting; Puts it as high as you can in the middleware stack
      app.middleware.insert_after Rack::Runtime, Api::DailyRateLimit
    end

  end
end
