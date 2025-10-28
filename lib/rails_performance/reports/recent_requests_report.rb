module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      def set_defaults
        @sort ||= :datetimei
      end

      def data
        time_agoi = RailsPerformance.recent_requests_time_window.ago.to_i
        db.data
          .collect { |e| e.record_hash }
          .select { |e| e if e[sort] > time_agoi }
          .sort { |a, b| b[sort] <=> a[sort] }
          .first(limit)
      end

      private

      def limit
        RailsPerformance.recent_requests_limit ? RailsPerformance.recent_requests_limit.to_i : 100_000
      end
    end
  end
end
