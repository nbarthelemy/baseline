require_relative 'boot'
require_relative "../lib/boot_inquirer"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# load the environment variables
Dotenv::Railtie.load

# Load sprockets if assets are required
if BootInquirer.assets_required?
  require "sprockets/railtie"
end

# require the enabled engines
BootInquirer.enabled(:engines).each do |engine|
  require engine.require_path
end

module Baseline
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Enable the asset pipline ( Sprockets ) if assets are required
    if BootInquirer.assets_required?
      config.assets.enabled = true

      # do not generate assets
      config.generators do |g|
        g.assets false
      end
    else
      # assume api_only mode if we are not serving assets
      config.api_only = true
    end

    # For each application load all of it's dependencies helper
    config.to_prepare { BootInquirer.load_enabled_app_helpers }
    config.before_initialize { BootInquirer.load_enabled_app_helpers }

    # derive unsubclassed models from dependencies
    config.to_prepare { BootInquirer.derive_enabled_app_models }
    config.after_initialize { BootInquirer.derive_enabled_app_models }

  end
end