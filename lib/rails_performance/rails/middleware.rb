module RailsPerformance
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @status, @headers, @response = @app.call(env)

        if record = Thread.current["RP_request_info"]
          begin
            record[:status]   ||= @status
            record[:request_id] = CurrentRequest.current.request_id
            RP::Utils.log_trace_in_redis(CurrentRequest.current.request_id, CurrentRequest.current.storage)
            RP::Utils.log_request_in_redis(record)
          ensure
            Thread.current["RP_request_info"] = nil
            CurrentRequest.cleanup
          end
        end

        [@status, @headers, @response]
      end

    end
  end
end