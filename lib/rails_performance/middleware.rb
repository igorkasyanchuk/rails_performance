module RailsPerformance
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      if record = Thread.current["RP_request_info"]
        record[:status] ||= @status
        RP::Utils.log_in_redis(record)
        Thread.current["RP_request_info"] = nil
      end

      [@status, @headers, @response]
    end

  end
end