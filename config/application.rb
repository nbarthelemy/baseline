require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# load the environment variables
Dotenv::Railtie.load

# require railties and engines here.
require_relative "../lib/boot_inquirer"

BootInquirer.enabled(:engines).each do |engine|
  require engine.name
end

module Baseline
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Disable the asset pipline ( Sprockets )
    # config.assets.enabled = false
    # config.generators do |g|
    #   g.assets false
    # end

    config.after_initialize do
      BootInquirer.enabled(:apps).each do |app|
        app.derive_models_from_dependencies
      end
    end

  end
end