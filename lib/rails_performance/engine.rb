require_relative './rails/middleware.rb'
require_relative './models/collection.rb'
require_relative './instrument/metrics_collector.rb'

module RailsPerformance
  class Engine < ::Rails::Engine

    if RailsPerformance.enabled
      config.app_middleware.insert_after ActionDispatch::Executor, RailsPerformance::Rails::Middleware
      initializer :configure_metrics, after: :initialize_logger do
        ActiveSupport::Notifications.subscribe(
          "process_action.action_controller",
          RailsPerformance::Instrument::MetricsCollector.new
        )

        config.after_initialize do |app|
          ActionView::LogSubscriber.send :prepend, RailsPerformance::Extensions::View
          ActiveRecord::LogSubscriber.send :prepend, RailsPerformance::Extensions::Db
        end
      end
    end

  end
end
