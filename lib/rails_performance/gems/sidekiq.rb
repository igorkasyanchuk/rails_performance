module RailsPerformance
  module Gems
    class Sidekiq

      def initialize(options=nil)
      end

      def call(worker, msg, queue)
        now  = Time.now
        data = {
          enqueued_ati: msg['enqueued_at'].to_i,
          created_ati: msg['created_at'].to_i,
          jid: msg['jid'],
          queue: queue,
          start_timei: now.to_i,
          datetime: now.strftime(RailsPerformance::FORMAT),
          worker: msg['wrapped'.freeze] || worker.class.to_s
        }
        begin
          yield
          data[:status]   = "success"
        rescue Exception => ex
          data[:status]   = "exception"
          data[:message]  = ex.message
          raise ex
        ensure
          # store in ms instead of seconds
          data[:duration] = (Time.now - now) * 1000
          #puts data
          RailsPerformance::Utils.log_job_in_redis(data)
        end
      end

    end
  end
end
