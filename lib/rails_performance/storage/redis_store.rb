module RailsPerformance
  module Storage
    class RedisStore < Base
      attr_reader :redis

      def initialize(redis: nil, **options)
        @redis = redis || build_redis(**options)
      end

      def write(key, value, expires_in:)
        redis.set(key, value, ex: expires_in.to_i)
      end

      def read(key)
        redis.get(key)
      end

      def fetch(pattern)
        keys = redis.keys(pattern)
        return [] if keys.blank?

        [keys, redis.mget(keys)]
      end

      def clear
        redis.flushdb
      end

      private

      def build_redis(**options)
        begin
          require "redis"
        rescue LoadError
          raise LoadError, "RailsPerformance: add `gem \"redis\"` to your Gemfile or configure another storage with `config.storage`"
        end

        Redis.new(**options)
      end
    end
  end
end
