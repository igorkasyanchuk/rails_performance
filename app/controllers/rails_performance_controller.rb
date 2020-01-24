class RailsPerformanceController < ActionController::Base

  def index
    @data   = RailsPerformance.dump
    @global = RailsPerformance::GlobalReport.new.data(:controller_action)
    #@full   = RailsPerformance::FullReport.new.data(:controller_action).sort{|a, b| b[:count] <=> a[:count]}
  end

end
