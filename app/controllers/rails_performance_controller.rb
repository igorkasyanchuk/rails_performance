class RailsPerformanceController < ActionController::Base

  def index
    @datasource = RailsPerformance::DataSource.new(
      q: {
        #  controller: "HomeController",
        #  action: "about"
      })

    @data   = RailsPerformance::ThroughputReport2.new(@datasource).data
    @global = RailsPerformance::GlobalReport.new(@datasource, group: :controller_action).data
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
