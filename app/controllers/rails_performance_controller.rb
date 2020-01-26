class RailsPerformanceController < ActionController::Base

  def index
    @datasource = RailsPerformance::DataSource.new(RailsPerformance::QueryBuilder.compose_from(params))

    @throughput_report         = RailsPerformance::Reports::ThroughputReport.new(@datasource.db)
    @throughput_report_data    = @throughput_report.data

    @response_time_report      = RailsPerformance::Reports::ResponseTimeReport.new(@datasource.db)
    @response_time_report_data = @response_time_report.data

    @global_report             = RailsPerformance::Reports::RequestsReport.new(@datasource.db, group: :controller_action_format, sort: :db_runtime_slowest)
    @global_report_data        = @global_report.data
  end

  # def RailsPerformanceController.x
  #   @datasource = RailsPerformance::DataSource.new(
  #     q: {
  #        controller: "HomeController",
  #        action: "about"
  #     })

  #   @data   = RailsPerformance::ThroughputReport2.new(@datasource).data
  # end

end
