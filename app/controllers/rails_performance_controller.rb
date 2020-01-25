class RailsPerformanceController < ActionController::Base

  def index
    @datasource = RailsPerformance::DataSource.new(
      q: {
        #  controller: "HomeController",
        #  action: "about"
      })

    @data   = RailsPerformance::ThroughputReport.new(@datasource.db).data
    @global = RailsPerformance::RequestsReport.new(@datasource.db, group: :controller_action_format, sort: :db_runtime_slowest).data
    #@full   = RailsPerformance::FullReport.new.data(:controller_action).sort{|a, b| b[:count] <=> a[:count]}
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
