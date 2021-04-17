module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      TIME_WINDOW = 60.minutes

      def set_defaults
        @sort ||= :datetimei
      end

      def data
        time_agoi = TIME_WINDOW.ago.to_i
        db.data.collect{|e| e.record_hash}.select{|e| e if e[sort] >= time_agoi}.sort{|a, b| b[sort] <=> a[sort]}
      end
    end
  end
end