module RailsPerformance
  module DashboardCharts
    class PercentileCard < Base
      def card?
        true
      end

      def percentile
        raise NotImplementedError
      end

      def label
        raise NotImplementedError
      end

      def value
        Reports::PercentileReport.new(datasource.db).data[percentile]
      end
    end

    class P50Card < PercentileCard
      def percentile
        :p50
      end

      def label
        "p50"
      end
    end

    class P95Card < PercentileCard
      def percentile
        :p95
      end

      def label
        "p95"
      end
    end

    class P99Card < PercentileCard
      def percentile
        :p99
      end

      def label
        "p99"
      end
    end
  end
end
