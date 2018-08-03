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

    # ensure migrations are available in the host app
    initializer :prepend_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'].unshift expanded_path
        end
      end
    end

  end
end
