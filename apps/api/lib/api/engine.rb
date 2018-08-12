require 'doorkeeper'
require 'devise'
require 'devise/doorkeeper'
require 'rack/cors'
require 'rack/attack'
require 'fast_jsonapi'
require 'swagger/docs'
require 'core'

module Api
  class Engine < ::Rails::Engine
    engine_name :api

    # use middlware for blocking and throttling
    config.middleware.use Rack::Attack
  end
end
