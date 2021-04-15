module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      TIME_WINDOW = 60.minutes

      def set_defaults
        @sort ||= :datetime
      end

      def data(type = :requests) # most popular type
        db.data
        .collect{|e| e.record_hash}
        .select{|e| e if e[:datetime] >= TIME_WINDOW.ago}
        .sort{|a, b| b[sort] <=> a[sort]}
      end
    end
  end
end