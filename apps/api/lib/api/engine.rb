require 'rack/cors'
require 'rack/attack'
require 'fast_jsonapi'
require 'swagger/docs'
require 'core'

module Api
  class Engine < ::Rails::Engine
    isolate_namespace Api

    # use middlware for blocking and throttling
    config.middleware.use Rack::Attack
  end
end
