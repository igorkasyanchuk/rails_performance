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
        RailsPerformance.log "== MiddlewareTraceStorerAndCleanup " * 5
        if %r{#{RailsPerformance.mount_at}}.match? env["PATH_INFO"]
          RailsPerformance.log "RailsPerformance in SKIP MODE"
          RailsPerformance.skip = true
        end

        @status, @headers, @response = @app.call(env)

        if !RailsPerformance.skip
          RP::Utils.log_trace_in_redis(CurrentRequest.current.request_id, CurrentRequest.current.storage)
        end
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
        RailsPerformance.log "  == Middleware " * 10
        @status, @headers, @response = @app.call(env)

        #t = Time.now
        if !RailsPerformance.skip
          if !CurrentRequest.current.ignore.include?(:performance) # grape is executed first, and than ignore regular future storage of "controller"-like request
            if record = CurrentRequest.current.record
              record[:status]   ||= @status # for 500 errors
              record[:request_id] = CurrentRequest.current.request_id

              # capture referer from where this page was opened
              record[:HTTP_REFERER] = env["HTTP_REFERER"] if record[:status] == 404

              # store for section "recent requests"
              # store request information (regular rails request)
              RP::Utils.log_request_in_redis(record)
            end
          end
        end
        #puts "==> store performance data: #{(Time.now - t).round(3)}ms"

        [@status, @headers, @response]
      end

    end
  end
end