module RailsPerformance
  module Widgets
    class ResponseTimeChart < Chart
      def initialize(datasource, subtitle: "Average Response Time Report", description: "All requests (site visitors, search engines, bots, etc)", legend: "Response Time", units: nil)
        super
      end

      def id
        "response_time_report_chart"
      end

      def type
        "RT"
      end

      def data
        Reports::ResponseTimeReport.new(datasource.db).data
      end
    end
  end
end
