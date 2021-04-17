module RailsPerformance
  module Reports
    class CrashReport < BaseReport
      def set_defaults
        @sort ||= :datetimei
      end

      def data
        db.data
          .collect{|e| e.record_hash}
          .sort{|a, b| b[sort] <=> a[sort]}
      end
    end


  end
end