module RailsPerformance
  module Widgets
    class CustomEventsTable < Table
      def subtitle
        "Recent Events (last #{RailsPerformance.recent_requests_time_window / 60} minutes)"
      end

      def data
        @data ||= RailsPerformance::Reports::RecentRequestsReport.new(datasource.db).data
      end

      def empty_message
        <<~HTML.html_safe
          Nothing to show here. Try to make a few requests in the main app.

          <pre>
            <code>
              # in controller for example
              def index
                RailsPerformance.measure("stats calculation", "reports#index") do
                  stats = User.calculate_stats
                end
              end
            </code>
          </pre>
        HTML
      end

      def show_export?
        false
      end

      def table_classes
        "table is-fullwidth is-hoverable is-narrow"
      end

      def content_partial_path
        "rails_performance/rails_performance/custom_events_table_content"
      end
    end
  end
end
