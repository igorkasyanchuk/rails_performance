module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      TIME_WINDOW = 60.minutes

      def set_defaults
        @sort ||= :datetimei
      end

      def data(from_timei = nil)
        time_agoi = [TIME_WINDOW.ago.to_i, from_timei.to_i].reject(&:blank?).max
        db.data
          .collect{|e| e.record_hash}
          .select{|e| e if e[sort] > time_agoi}
          .sort{|a, b| b[sort] <=> a[sort]}
      end
    end
  end
end