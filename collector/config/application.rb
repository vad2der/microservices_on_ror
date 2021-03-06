require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Collector
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client', 'content-type', 'cache-control'],
          :methods => [:get, :post, :options, :delete, :put]
      end
    end
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths << "#{Rails.root}/lib"
    config.time_zone = "America/Edmonton"
    # config.force_ssl = true 
    # config.action_dispatch.default_headers = {
    #   'Access-Control-Allow-Origin' => 'https://skymatics-dd-cda-admin.herokuapp.com',
    #   'Access-Control-Allow-Credentials' => "true"
    # }
    Mongoid.load!('./config/mongoid.yml')
    config.after_initialize do
      EntriesCheck.deliver_entries()
    end
  end
end
