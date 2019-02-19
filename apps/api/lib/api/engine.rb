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
  end
end
