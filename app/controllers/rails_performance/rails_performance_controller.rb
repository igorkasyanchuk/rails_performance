require_relative "base_controller"

module RailsPerformance
  class RailsPerformanceController < RailsPerformance::BaseController
    protect_from_forgery except: :recent

    if RailsPerformance.enabled
      def index
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :requests)

        @widgets = RailsPerformance.dashboard_charts.map do |row|
          if row.is_a?(Array)
            row.map { |class_name| Widgets.const_get(class_name).new(@datasource) }
          else
            Widgets.const_get(row).new(@datasource)
          end
        end
      end

      def resources
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :resources, days: RailsPerformance::Utils.days(RailsPerformance.system_monitor_duration))
        db = @datasource.db

        @resources_report = RailsPerformance::Reports::ResourcesReport.new(db)
      end

      def summary
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :requests)
        db = @datasource.db

        @throughput_report_data = RailsPerformance::Reports::ThroughputReport.new(db).data
        @response_time_report_data = RailsPerformance::Reports::ResponseTimeReport.new(db).data
        @data = RailsPerformance::Reports::BreakdownReport.new(db, title: "Requests").data
        respond_to do |format|
          format.js {}
          format.any do
            render plain: "Doesn't open in new window. Wait until full page load."
          end
        end
      end

      def trace
        @record = RailsPerformance::Models::RequestRecord.find_by(request_id: params[:id])
        @data = RailsPerformance::Reports::TraceReport.new(request_id: params[:id]).data
        respond_to do |format|
          format.js {}
          format.any do
            render plain: "Doesn't open in new window. Wait until full page load."
          end
        end
      end

      def crashes
        @datasource = RailsPerformance::DataSource.new(**prepare_query({status_eq: 500}), type: :requests)
        @table = Widgets::CrashesTable.new(@datasource)

        respond_to do |format|
          format.html
          format.csv do
            export_to_csv "error_report", @table.data
          end
        end
      end

      def requests
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :requests)
        @table = Widgets::RequestsTable.new(@datasource)

        respond_to do |format|
          format.html
          format.csv do
            export_to_csv "requests_report", @table.data
          end
        end
      end

      def recent
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :requests)
        @table = Widgets::RecentRequestsTable.new(@datasource)

        respond_to do |format|
          format.html
          format.csv do
            export_to_csv "recent_requests_report", @table.data
          end
        end
      end

      def slow
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :requests)
        @table = Widgets::SlowRequestsTable.new(@datasource)

        respond_to do |format|
          format.html
          format.csv do
            export_to_csv "slow_requests_report", @table.data
          end
        end
      end

      def sidekiq
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :sidekiq)
        @widgets = [
          Widgets::ThroughputChart.new(@datasource, subtitle: "Sidekiq Workers Throughput Report", legend: "Jobs", units: "jobs / minute"),
          Widgets::ResponseTimeChart.new(@datasource, subtitle: "Average Execution Time"),
          Widgets::SidekiqJobsTable.new(@datasource)
        ]
      end

      def delayed_job
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :delayed_job)
        @widgets = [
          Widgets::ThroughputChart.new(@datasource, subtitle: "Delayed::Job Workers Throughput Report", legend: "Jobs", units: "jobs / minute"),
          Widgets::ResponseTimeChart.new(@datasource, subtitle: "Average Execution Time"),
          Widgets::DelayedJobTable.new(@datasource)
        ]
      end

      def custom
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :custom)
        @widgets = [
          Widgets::CustomEventsTable.new(@datasource),
          Widgets::ThroughputChart.new(@datasource, subtitle: "Custom Events Throughput Report", legend: "Events", units: "events / minute"),
          Widgets::ResponseTimeChart.new(@datasource, subtitle: "Average Execution Time")
        ]
      end

      def grape
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :grape)
        @widgets = [
          Widgets::ThroughputChart.new(@datasource, subtitle: "Grape Throughput Report"),
          Widgets::GrapeRequestsTable.new(@datasource)
        ]
      end

      def rake
        @datasource = RailsPerformance::DataSource.new(**prepare_query(params), type: :rake)
        @widgets = [
          Widgets::RakeTasksTable.new(@datasource),
          Widgets::ThroughputChart.new(@datasource, subtitle: "Rake Throughput Report", legend: "Tasks", units: "tasks / minute")
        ]
      end

      private

      def prepare_query(query = {})
        RailsPerformance::Rails::QueryBuilder.compose_from(query)
      end
    end
  end
end
