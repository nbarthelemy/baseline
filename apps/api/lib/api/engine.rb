require 'rack/cors'
require 'rack/attack'
require 'fast_jsonapi'
require 'swagger/docs'
require 'core'

module Api
  class Engine < ::Rails::Engine
    isolate_namespace Api

    # set rails to api_only mode
    config.api_only = true

    # use middlware for blocking and throttling
    config.middleware.use Rack::Attack

  end
end
