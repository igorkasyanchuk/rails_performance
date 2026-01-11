module RailsPerformance
  module Widgets
    class ThroughputChart < Chart
      def id
        "throughput_report_chart"
      end

      def type
        "TIR"
      end

      def subtitle
        "Throughput Report"
      end

      def description
        "All requests (site visitors, search engines, bots, etc)"
      end

      def legend
        "RPM"
      end

      def units
        "rpm"
      end

      def data
        Reports::ThroughputReport.new(datasource.db).data
      end
    end
  end
end
