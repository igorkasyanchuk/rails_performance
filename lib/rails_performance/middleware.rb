module RailsPerformance
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      # if RailsPerformance.debug
      #   key   = RailsPerformance::Utils.cache_key
      #   field = RailsPerformance::Utils.field_key
      #   puts "key: #{key}, field: #{field}"
      #   RailsPerformance.redis.hincrby(key, field, 1)
      # else
        RP.redis.hincrby(RP::Utils.cache_key, RP::Utils.field_key, 1)
#      end

      [@status, @headers, @response]
    end

  end
end