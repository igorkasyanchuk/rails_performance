require_relative './middleware.rb'
require_relative './collection.rb'
require_relative './metrics_listener.rb'

module RailsPerformance
  class Engine < ::Rails::Engine

    #config.app_middleware.use RailsPerformance::Middleware
    config.app_middleware.insert_after ActionDispatch::Executor, RailsPerformance::Middleware

    initializer :configure_metrics, after: :initialize_logger do
      ActiveSupport::Notifications.subscribe(
        "process_action.action_controller",
        RailsPerformance::MetricsListener.new
      )
    end

  end
end
