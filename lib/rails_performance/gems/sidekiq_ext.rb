module RailsPerformance
  module Gems
    class SidekiqExt

      def initialize(options=nil)
      end

      def call(worker, msg, queue)
        now    = Time.current
        record = RailsPerformance::Models::SidekiqRecord.new(
          enqueued_ati: msg['enqueued_at'].to_i,
          datetimei: msg['created_at'].to_i,
          jid: msg['jid'],
          queue: queue,
          start_timei: now.to_i,
          datetime: now.strftime(RailsPerformance::FORMAT),
          worker: msg['wrapped'.freeze] || worker.class.to_s
        )
        begin
          result = yield
          record.status = "success"
          result
        rescue Exception => ex
          record.status   = "exception"
          record.message  = ex.message
          raise ex
        ensure
          # store in ms instead of seconds
          record.duration = (Time.current - now) * 1000
          record.save
          result
        end
      end

    end
  end
end
