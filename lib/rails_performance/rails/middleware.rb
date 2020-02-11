module RailsPerformance
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @status, @headers, @response = @app.call(env)

        #t = Time.now
        if record = CurrentRequest.current.record
          begin
            record[:status]   ||= @status # for 500 errors
            record[:request_id] = CurrentRequest.current.request_id

            # capture referer from where this page was opened
            if record[:status] == 404
              record[:HTTP_REFERER] = env["HTTP_REFERER"]
            end

            # store for section "recent requests"
            RP::Utils.log_trace_in_redis(CurrentRequest.current.request_id, CurrentRequest.current.storage)

            # store request information
            RP::Utils.log_request_in_redis(record)
          ensure
            # we don't want to have a memory leak
            CurrentRequest.cleanup
          end
        end
        #puts "==> store performance data: #{(Time.now - t).round(3)}ms"

        [@status, @headers, @response]
      end

    end
  end
end