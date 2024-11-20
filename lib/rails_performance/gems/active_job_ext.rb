module RailsPerformance
  module Gems
    class ActiveJobExt
      module AroundPerform
        extend ActiveSupport::Concern

        included do
          around_perform do |job, block|
            now = Time.now
            exception = nil
            record = RailsPerformance::Models::ActiveJobRecord.new(
              worker: job.class.name,
              queue: job.queue_name,
              enqueued_ati: job.enqueued_at.to_i,
              datetimei: job.scheduled_at.to_i,
              jid: job.job_id,
              start_timei: now.to_i,
              datetime: now.strftime(RailsPerformance::FORMAT)
            )
            result = block.call
            record.status = "success"
            result
          rescue Exception => ex # rubocop:disable Lint/RescueException
            record.status = "exception"
            record.message = ex.message
            exception = ex
          ensure
            # store in ms instead of seconds
            record.duration = (Time.current - now) * 1000
            record.save
            raise exception if exception
          end
        end
      end

      def self.init
        ActiveJob::Base.send :include, AroundPerform
      end
    end
  end
end
