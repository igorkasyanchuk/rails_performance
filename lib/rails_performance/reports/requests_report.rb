module RailsPerformance
  module Reports
    class RequestsReport < BaseReport
      def set_defaults
        @sort ||= :count
      end

      def data
        collect do |k, v|
          durations     = v.collect{|e| e["duration"]}.compact
          view_runtimes = v.collect{|e| e["view_runtime"]}.compact
          db_runtimes   = v.collect{|e| e["db_runtime"]}.compact
          {
            group:                k,
            count:                v.size,
            duration_average:     durations.sum.to_f / durations.size,
            view_runtime_average: view_runtimes.sum.to_f / view_runtimes.size,
            db_runtime_average:   db_runtimes.sum.to_f / db_runtimes.size,
            duration_slowest:     durations.max,
            view_runtime_slowest: view_runtimes.max,
            db_runtime_slowest:   db_runtimes.max,
          }
        end.sort_by{|e| -e[sort].to_f} # to_f because could ne NaN or nil
      end
    end
  end
end