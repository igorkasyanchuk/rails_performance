module RailsPerformance
  module Reports
    class PercentileReport < BaseReport
      def data
        durations = db.data.collect(&:duration).compact
        {
          p50: RailsPerformance::Utils.percentile(durations, 50),
          p95: RailsPerformance::Utils.percentile(durations, 95),
          p99: RailsPerformance::Utils.percentile(durations, 99)
        }
      end
    end
  end
end
