require_relative './base_controller.rb'

class RailsPerformanceController < BaseController

  if RailsPerformance.enabled
    def index
      @datasource                = RP::DataSource.new(prepare_query)
      db                         = @datasource.db

      @throughput_report         = RP::Reports::ThroughputReport.new(db)
      @throughput_report_data    = @throughput_report.data

      @response_time_report      = RP::Reports::ResponseTimeReport.new(db)
      @response_time_report_data = @response_time_report.data
    end

    def summary
      @datasource                = RP::DataSource.new(prepare_query)
      db                         = @datasource.db

      @throughput_report         = RP::Reports::ThroughputReport.new(db)
      @throughput_report_data    = @throughput_report.data

      @response_time_report      = RP::Reports::ResponseTimeReport.new(db)
      @response_time_report_data = @response_time_report.data

      @report                    = RP::Reports::BreakdownReport.new(db, title: "Requests")
      @data                      = @report.data

      respond_to do |format|
        format.js {}
        format.any { render plain: "Doesn't open in new window" }
      end
    end

    def trace
      @record = RP::Models::Record.find_by(request_id: params[:id])
      @report = RP::Reports::TraceReport.new(request_id: params[:id])
      @data   = @report.data
      respond_to do |format|
        format.js {}
        format.any { render plain: "Doesn't open in new window" }
      end
    end

    def crashes
      @datasource   = RP::DataSource.new(prepare_query({status_eq: 500}))
      db            = @datasource.db
      @report       = RP::Reports::CrashReport.new(db)
      @data         = @report.data
    end

    def requests
      @datasource = RP::DataSource.new(prepare_query)
      db          = @datasource.db
      @report     = RP::Reports::RequestsReport.new(db, group: :controller_action_format, sort: :count)
      @data       = @report.data
    end

    def recent
      @datasource = RP::DataSource.new(prepare_query)
      db          = @datasource.db
      @report     = RP::Reports::RecentRequestsReport.new(db)
      @data       = @report.data
    end

    private

    def prepare_query(query = params)
      RP::Rails::QueryBuilder.compose_from(query)
    end
  end

end
