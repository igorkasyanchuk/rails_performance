module RailsPerformance
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @status, @headers, @response = @app.call(env)

        if !Thread.current[:in_rails_performance] && record = Thread.current["RP_request_info"]
          record[:status]   ||= @status
          record[:request_id] = CurrentRequest.current.request_id

          # rand(500).times do |e|
          #   finished               = Time.now - rand(2000).minutes
          #   record[:datetime]      = finished.strftime(RailsPerformance::FORMAT)
          #   record[:datetimei]     = finished.to_i
          #   record[:duration]      = 50 + rand(100) + rand(50.0) + rand(e)
          #   record[:db_runtime]    = rand(50.0)
          #   record[:view_runtime]  = rand(50.0)
          #   RP::Utils.log_request_in_redis(record)
          # end

          RP::Utils.log_trace_in_redis(CurrentRequest.current.request_id, CurrentRequest.current.storage)
          RP::Utils.log_request_in_redis(record)
          Thread.current["RP_request_info"] = nil
          CurrentRequest.cleanup
        end

        [@status, @headers, @response]
      end

    end
  end
end