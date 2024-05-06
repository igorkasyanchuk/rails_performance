require 'action_view/log_subscriber'
require_relative './rails/middleware.rb'
require_relative './models/collection.rb'
require_relative './instrument/metrics_collector.rb'

module RailsPerformance
  class Engine < ::Rails::Engine
    isolate_namespace RailsPerformance

    initializer "rails_performance.middleware" do |app|
      next unless RailsPerformance.enabled

      if ::Rails::VERSION::MAJOR.to_i >= 5
        app.middleware.insert_after ActionDispatch::Executor, RailsPerformance::Rails::Middleware
      else
        begin
          app.middleware.insert_after ActionDispatch::Static, RailsPerformance::Rails::Middleware
        rescue
          app.middleware.insert_after Rack::SendFile, RailsPerformance::Rails::Middleware
        end
      end
      # look like it works in reverse order?
      app.middleware.insert_before RailsPerformance::Rails::Middleware, RailsPerformance::Rails::MiddlewareTraceStorerAndCleanup

      if defined?(::Sidekiq)
        require_relative './gems/sidekiq_ext.rb'
        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add RailsPerformance::Gems::SidekiqExt
          end
        end
      end

      if defined?(::Grape)
        require_relative './gems/grape_ext.rb'
        RailsPerformance::Gems::GrapeExt.init
      end

      if defined?(::Delayed::Job)
        require_relative './gems/delayed_job_ext.rb'
        RailsPerformance::Gems::DelayedJobExt.init
      end
    end

    initializer :configure_metrics, after: :initialize_logger do
      next unless RailsPerformance.enabled

      ActiveSupport::Notifications.subscribe(
        "process_action.action_controller",
        RailsPerformance::Instrument::MetricsCollector.new
      )
    end

    config.after_initialize do
      next unless RailsPerformance.enabled

      ActionView::LogSubscriber.send :prepend, RailsPerformance::Extensions::View
      ActiveRecord::LogSubscriber.send :prepend, RailsPerformance::Extensions::Db if defined?(ActiveRecord)

      if defined?(::Rake::Task) && RailsPerformance.include_rake_tasks
        require_relative './gems/rake_ext.rb'
        RailsPerformance::Gems::RakeExt.init
      end
    end
  end
end
