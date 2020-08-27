require_relative './rails/middleware.rb'
require_relative './models/collection.rb'
require_relative './instrument/metrics_collector.rb'

module RailsPerformance
  class Engine < ::Rails::Engine
    isolate_namespace RailsPerformance

    if RailsPerformance.try(:enabled) # for rails c

      if ::Rails::VERSION::MAJOR.to_i >= 5
        config.app_middleware.insert_after ActionDispatch::Executor, RailsPerformance::Rails::Middleware
      else
        config.app_middleware.insert_after ActionDispatch::Static, RailsPerformance::Rails::Middleware
      end

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

      if const_defined?("Sidekiq")
        require_relative './gems/sidekiq.rb'
        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add RailsPerformance::Gems::Sidekiq
          end
        end
      end

    end

  end
end
