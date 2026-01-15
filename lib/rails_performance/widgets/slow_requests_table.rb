module RailsPerformance
  module Widgets
    class SlowRequestsTable < Table
      def subtitle
        "Slow Requests (last #{RailsPerformance.slow_requests_time_window / 60} minutes + slower than #{RailsPerformance.slow_requests_threshold}ms)"
      end

      def data
        @data ||= RailsPerformance::Reports::SlowRequestsReport.new(datasource.db).data
      end

      def empty_message
        "Nothing to show here. Try to make a few requests in the main app."
      end

      def table_id
        "recent"
      end

      def table_classes
        "table is-fullwidth is-hoverable is-narrow"
      end

      def content_partial_path
        "rails_performance/rails_performance/recent_requests_table_content"
      end
    end
  end
end
