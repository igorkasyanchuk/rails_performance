module RailsPerformance
  module Widgets
    class ThroughputChart < Chart
      def initialize(datasource, subtitle: "Throughput Report", description: "All requests (site visitors, search engines, bots, etc)", legend: "RPM", units: "rpm")
        super
      end

      def id
        "throughput_report_chart"
      end

      def type
        "TIR"
      end

      def data
        Reports::ThroughputReport.new(datasource.db).data
      end
    end
  end
end
