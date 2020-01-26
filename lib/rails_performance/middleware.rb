module RailsPerformance
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      if record = Thread.current["RP_request_info"]
        record[:status] ||= @status

        # rand(100).times do |e|
        #   finished = Time.now - rand(2000).minutes
        #   record[:datetime]  = finished.strftime(RailsPerformance::MetricsCollector::FORMAT)
        #   record[:datetimei] = finished.to_i
        #   record[:duration]      = rand(record[:duration].to_f * 2)
        #   record[:db_runtime]    = rand(record[:db_runtime].to_f * 2)
        #   record[:view_runtime]  = rand(record[:view_runtime].to_f * 2)
        #   RP::Utils.log_in_redis(record)
        # end

        RP::Utils.log_in_redis(record)

        Thread.current["RP_request_info"] = nil
      end

      [@status, @headers, @response]
    end

  end
end