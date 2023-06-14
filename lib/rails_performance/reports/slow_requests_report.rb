module RailsPerformance
  module Reports
    class SlowRequestsReport < BaseReport
      def set_defaults
        @sort ||= :datetimei
      end

      def data
        db.data
          .collect{|e| e.record_hash}
          .select{|e| e if e[sort] > RailsPerformance.slow_requests_time_window.ago.to_i}
          .sort{|a, b| b[sort] <=> a[sort]}
          .filter{|e| e[:duration] > RailsPerformance.slow_requests_threshold.to_i}
          .first(limit)
      end

      private

      def limit
        RailsPerformance.slow_requests_limit ? RailsPerformance.slow_requests_limit.to_i : 100_000
      end
    end
  end
end
