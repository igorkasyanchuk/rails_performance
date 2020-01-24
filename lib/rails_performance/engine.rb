require_relative './middleware.rb'
require_relative './collection.rb'
require_relative './metrics.rb'

module RailsPerformance
  class Engine < ::Rails::Engine

    config.app_middleware.use Middleware

    initializer :configure_metrics, after: :initialize_logger do
      ActiveSupport::Notifications.subscribe(
        "process_action.action_controller",
        Metrics.new
      )
    end

  end
end
