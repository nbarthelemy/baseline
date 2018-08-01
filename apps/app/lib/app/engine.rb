require 'core'
require 'devise'

module App
  class Engine < ::Rails::Engine
    isolate_namespace App

    # set devise controller layouts
    config.to_prepare do
      Devise::SessionsController.layout 'devise/card'
      Devise::RegistrationsController.layout proc{|controller| user_signed_in? ? 'application' : 'devise/full-split' }
      Devise::ConfirmationsController.layout 'devise/card'
      Devise::UnlocksController.layout 'devise/card'
      Devise::PasswordsController.layout 'devise/card'
    end

  end
end
