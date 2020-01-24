module RailsPerformance
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      record = Thread.current["RP_request_info"]

      record[:status] ||= @status

      RP::Utils.log_in_redis(record)

      [@status, @headers, @response]
    end

  end
end