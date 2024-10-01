module RailsPerformance
  module Gems
    class ActiveJobExt
      def self.init
        ActiveSupport::Notifications.subscribe(
          # "perform.active_job",
          /\A[^\.]+\.active_job\z/,
          RailsPerformance::Instrument::ActiveJobMetricsCollector.new
        )
      end
    end
  end
end
