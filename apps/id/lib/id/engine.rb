require 'doorkeeper'
require 'devise'
require 'devise/doorkeeper'
require 'core'
require 'ui'

module Id
  class Engine < ::Rails::Engine
    isolate_namespace Id

    # set devise controller layouts
    config.to_prepare do
      Devise::SessionsController.layout 'devise/card'
      Devise::RegistrationsController.layout proc{|controller| user_signed_in? ? 'application' : 'devise/full-split' }
      Devise::ConfirmationsController.layout 'devise/card'
      Devise::UnlocksController.layout 'devise/card'
      Devise::PasswordsController.layout 'devise/card'
    end

    initializer :prepend_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'].unshift expanded_path
        end
      end
    end

    initializer :prepend_seeds do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/seeds.rb'].expanded.each do |expanded_path|
          app.config.paths['db/seeds.rb'].unshift expanded_path
        end
      end
    end

  end
end
