module RailsPerformance
  module Widgets
    class RakeTasksTable < Table
      def subtitle
        "Recent Rake tasks (last #{RailsPerformance.recent_requests_time_window / 60} minutes)"
      end

      def data
        @data ||= RailsPerformance::Reports::RecentRequestsReport.new(datasource.db).data
      end

      def empty_message
        "Nothing to show here. Try to make a few requests in the main app."
      end

      def show_export?
        false
      end

      def table_classes
        "table is-fullwidth is-hoverable is-narrow"
      end

      def content_partial_path
        "rails_performance/rails_performance/rake_tasks_table_content"
      end
    end
  end
end
