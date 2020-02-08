module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      TIME_WINDOW = 60 # 60 minutes

      def set_defaults
        @sort ||= :datetime
      end

      def data
        db.data.collect do |record|
          {
            controller: record.controller,
            action: record.action,
            format: record.format,
            status: record.status,
            method: record.method,
            path: record.path,
            datetime: Time.at(record.datetimei.to_i),
            duration: record.value['duration'],
            db_runtime: record.value['db_runtime'],
            view_runtime: record.value['view_runtime'],
          }
        end
        .select{|e| e if e[:datetime] >= TIME_WINDOW.minutes.ago}
        .sort{|a, b| b[sort] <=> a[sort]}
      end
    end


  end
end