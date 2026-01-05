module RailsPerformance
  module DashboardCharts
    class ResponseTimeChart < Base
      def id
        "response_time_report_chart"
      end

      def type
        "RT"
      end

      def subtitle
        "Average Response Time Report"
      end

      def description
        "All requests (site visitors, search engines, bots, etc)"
      end

      def legend
        "Response Time"
      end

      def data
        Reports::ResponseTimeReport.new(datasource.db).data
      end
    end
  end
end
