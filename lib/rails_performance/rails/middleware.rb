module RailsPerformance
  module Rails
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        @status, @headers, @response = @app.call(env)

        if record = Thread.current["RP_request_info"]
          record[:status] ||= @status

          # rand(500).times do |e|
          #   finished               = Time.now - rand(2000).minutes
          #   record[:datetime]      = finished.strftime(RailsPerformance::FORMAT)
          #   record[:datetimei]     = finished.to_i
          #   record[:duration]      = 50 + rand(100) + rand(50.0) + rand(e)
          #   record[:db_runtime]    = rand(50.0)
          #   record[:view_runtime]  = rand(50.0)
          #   RP::Utils.log_in_redis(record)
          # end

          RP::Utils.log_in_redis(record)

          Thread.current["RP_request_info"] = nil
        end

        [@status, @headers, @response]
      end

    end
  end
end