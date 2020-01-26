require_relative './middleware.rb'
require_relative './collection.rb'
require_relative './metrics_collector.rb'

module RailsPerformance
  class Engine < ::Rails::Engine

    #config.app_middleware.use RailsPerformance::Middleware
    config.app_middleware.insert_after ActionDispatch::Executor, RailsPerformance::Middleware

    initializer :configure_metrics, after: :initialize_logger do
      ActiveSupport::Notifications.subscribe(
        "process_action.action_controller",
        RailsPerformance::MetricsCollector.new
      )
    end

    # initializer 'rails_performance.helpers' do
    #   ActiveSupport.on_load :action_view do
    #     ActionView::Base.send :include, RailsPerformance::RailsPerformanceHelper
    #   end
    # end

  end
end
