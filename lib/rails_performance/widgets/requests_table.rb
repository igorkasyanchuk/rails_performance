module RailsPerformance
  module Widgets
    class RequestsTable < Table
      def subtitle
        "Requests Analysis"
      end

      def data
        @data ||= RailsPerformance::Reports::RequestsReport.new(
          datasource.db,
          group: :controller_action_format,
          sort: :count
        ).data
      end

      def empty_message
        "No requests recorded yet."
      end

      def content_partial_path
        "rails_performance/rails_performance/requests_table_content"
      end
    end
  end
end
