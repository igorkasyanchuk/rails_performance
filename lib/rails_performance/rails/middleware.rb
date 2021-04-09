module RailsPerformance
  module Rails
    class MiddlewareTraceStorerAndCleanup
      def initialize(app)
        @app = app
      end

      def call(env)
        dup.call!(env)
      end

      def call!(env)
        @status, @headers, @response = @app.call(env)

        RP::Utils.log_trace_in_redis(CurrentRequest.current.request_id, CurrentRequest.current.storage)
        CurrentRequest.cleanup

        [@status, @headers, @response]
      end
    end

    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        dup.call!(env)
      end

      def call!(env)
        @status, @headers, @response = @app.call(env)

        #t = Time.now
        if !CurrentRequest.current.ignore.include?(:performance) && # grape is executed first, and than ignore regular future storage of "controller"-like request
          record = CurrentRequest.current.record

          record[:status]   ||= @status # for 500 errors
          record[:request_id] = CurrentRequest.current.request_id

          # capture referer from where this page was opened
          record[:HTTP_REFERER] = env["HTTP_REFERER"] if record[:status] == 404

          # store for section "recent requests"

          # store request information (regular rails request)
          RP::Utils.log_request_in_redis(record)
        end
        #puts "==> store performance data: #{(Time.now - t).round(3)}ms"

        [@status, @headers, @response]
      end

    end
  end
end