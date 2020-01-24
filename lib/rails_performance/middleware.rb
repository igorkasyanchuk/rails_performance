module RailsPerformance
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      # if RailsPerformance.debug
      #   key   = RailsPerformance.cache_key
      #   field = RailsPerformance.field_key
      #   puts "key: #{key}, field: #{field}"
      #   RailsPerformance.redis.hincrby(key, field, 1)
      # else
        RailsPerformance.redis.hincrby(RailsPerformance.cache_key, RailsPerformance.field_key, 1)
#      end

      [@status, @headers, @response]
    end

  end
end