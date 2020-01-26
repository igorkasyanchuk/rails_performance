class RailsPerformanceController < ActionController::Base

  def index
    @datasource = RailsPerformance::DataSource.new(RailsPerformance::QueryBuilder.compose_from(params))

    @throughput_report      = RailsPerformance::ThroughputReport.new(@datasource.db)
    @throughput_report_data = @throughput_report.data

    @global_report          = RailsPerformance::RequestsReport.new(@datasource.db, group: :controller_action_format, sort: :db_runtime_slowest)
    @global_report_data     = @global_report.data
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
