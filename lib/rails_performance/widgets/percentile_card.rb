module RailsPerformance
  module Widgets
    class PercentileCard < Card
      def value
        Reports::PercentileReport.new(datasource.db).data[label.to_sym]
      end
    end

    class P50Card < PercentileCard
      def label = "p50"
    end

    class P95Card < PercentileCard
      def label = "p95"
    end

    class P99Card < PercentileCard
      def label = "p99"
    end
  end
end
