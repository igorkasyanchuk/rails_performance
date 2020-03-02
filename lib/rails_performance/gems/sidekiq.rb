module RailsPerformance
  module Gems
    class Sidekiq

      def initialize(options=nil)
      end

      def call(worker, msg, queue)
        data = {
          enqueued_ati: msg['enqueued_at'].to_i,
          created_ati: msg['created_at'].to_i,
          jid: msg['jid'],
          queue: queue,
          start_timei: Time.now,
          worker: msg['wrapped'.freeze] || worker.class.to_s
        }
        begin
          yield
          data[:status] = "success"
        rescue Exception => ex
          data[:status]  = "exception"
          data[:message] = ex.message
        ensure
          data[:duration]    = Time.now - data[:start_timei]
          data[:start_timei] = data[:start_timei].to_i # to count duration
          puts data
          RailsPerformance::Utils.log_job_in_redis(data)
        end
      end

    end
  end
end
