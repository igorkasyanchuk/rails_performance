require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "rails_performance"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.time_zone = "Europe/Kiev"

    config.hosts.clear

    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += Dir["#{Rails.root}/app/api/*"]
    config.eager_load_paths += Dir["#{Rails.root}/app/api/*"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
