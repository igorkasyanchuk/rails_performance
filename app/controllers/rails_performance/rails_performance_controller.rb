require_relative './base_controller.rb'

module RailsPerformance
  class RailsPerformanceController < RailsPerformance::BaseController
    include RailsPerformance::ApplicationHelper

    if RailsPerformance.enabled
      def index
        @datasource                = RP::DataSource.new(**prepare_query, type: :requests)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @response_time_report_data = RP::Reports::ResponseTimeReport.new(db).data
      end

      def summary
        @datasource                = RP::DataSource.new(**prepare_query, type: :requests)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @response_time_report_data = RP::Reports::ResponseTimeReport.new(db).data
        @data                      = RP::Reports::BreakdownReport.new(db, title: "Requests").data

        respond_to do |format|
          format.js {}
          format.any { render plain: "Doesn't open in new window. Wait until full page load." }
        end
      end

      def trace
        @record = RP::Models::RequestRecord.find_by(request_id: params[:id])
        @data   = RP::Reports::TraceReport.new(request_id: params[:id]).data
        respond_to do |format|
          format.js {}
          format.any { render plain: "Doesn't open in new window. Wait until full page load." }
        end
      end

      def crashes
        @datasource   = RP::DataSource.new(**prepare_query({status_eq: 500}), type: :requests)
        db            = @datasource.db
        @data         = RP::Reports::CrashReport.new(db).data
      end

      def requests
        @datasource = RP::DataSource.new(**prepare_query, type: :requests)
        db          = @datasource.db
        @data       = RP::Reports::RequestsReport.new(db, group: :controller_action_format, sort: :count).data
      end

      def recent
        @datasource = RP::DataSource.new(**prepare_query, type: :requests)
        db          = @datasource.db
        @data       = RP::Reports::RecentRequestsReport.new(db).data
      end

      def sidekiq
        @datasource                = RP::DataSource.new(**prepare_query, type: :sidekiq)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @response_time_report_data = RP::Reports::ResponseTimeReport.new(db).data
        @recent_report_data        = RP::Reports::RecentRequestsReport.new(db).data
      end

      def delayed_job
        @datasource                = RP::DataSource.new(**prepare_query, type: :delayed_job)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @response_time_report_data = RP::Reports::ResponseTimeReport.new(db).data
        @recent_report_data        = RP::Reports::RecentRequestsReport.new(db).data
      end

      def grape
        @datasource                = RP::DataSource.new(**prepare_query, type: :grape)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @recent_report_data        = RP::Reports::RecentRequestsReport.new(db).data
      end

      def rake
        @datasource                = RP::DataSource.new(**prepare_query, type: :rake)
        db                         = @datasource.db

        @throughput_report_data    = RP::Reports::ThroughputReport.new(db).data
        @recent_report_data        = RP::Reports::RecentRequestsReport.new(db).data
      end

      private

      def prepare_query(query = params)
        RP::Rails::QueryBuilder.compose_from(query)
      end
    end

  end
end