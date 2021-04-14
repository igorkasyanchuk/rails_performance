module RailsPerformance
  module Gems
    class Sidekiq

      def initialize(options=nil)
      end

      def call(worker, msg, queue)
        now  = Time.now
        record = RP::Models::JobRecord.new(
          enqueued_ati: msg['enqueued_at'].to_i,
          created_ati: msg['created_at'].to_i,
          jid: msg['jid'],
          queue: queue,
          start_timei: now.to_i,
          datetime: now.strftime(RailsPerformance::FORMAT),
          worker: msg['wrapped'.freeze] || worker.class.to_s
        )
        begin
          yield
          record.status   = "success"
        rescue Exception => ex
          record.status   = "exception"
          record.message  = ex.message
          raise ex
        ensure
          # store in ms instead of seconds
          record.duration = (Time.now - now) * 1000
          #puts data
          record.save
        end
      end

    end
  end
end
