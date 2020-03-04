module RailsPerformance
  module Reports
    class RecentRequestsReport < BaseReport
      TIME_WINDOW = 60.minutes

      def set_defaults
        @sort ||= :datetime
      end

      def data(type = :requests) # most popular type
        db.data.collect do |record|
          case type
          when :requests
            record_hash(record)
          when :jobs
            job_hash(record)
          end
        end
        .select{|e| e if e[:datetime] >= TIME_WINDOW.ago}
        .sort{|a, b| b[sort] <=> a[sort]}
      end

      private

      def record_hash(record)
        {
          controller: record.controller,
          action: record.action,
          format: record.format,
          status: record.status,
          method: record.method,
          path: record.path,
          request_id: record.request_id,
          datetime: Time.at(record.datetimei.to_i),
          duration: record.value['duration'],
          db_runtime: record.value['db_runtime'],
          view_runtime: record.value['view_runtime'],
        }
      end

      def job_hash(record)
        {
          worker: record.worker,
          queue: record.queue,
          
          jid: record.jid,
          status: record.status,
          datetime: Time.at(record.start_timei.to_i),
          duration: record.value['duration'],
        }
      end
    end


  end
end