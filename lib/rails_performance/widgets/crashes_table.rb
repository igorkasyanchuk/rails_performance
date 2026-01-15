module RailsPerformance
  module Widgets
    class CrashesTable < Table
      def subtitle
        "Crash Report"
      end

      def data
        @data ||= RailsPerformance::Reports::CrashReport.new(datasource.db).data
      end

      def empty_message
        "We are glad that this list is empty ;)"
      end

      def table_classes
        "table is-fullwidth is-hoverable is-narrow"
      end

      def content_partial_path
        "rails_performance/rails_performance/crashes_table_content"
      end
    end
  end
end
