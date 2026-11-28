require "test_helper"
require "redis"

class RedisStoreTest < ActiveSupport::TestCase
  include StorageContract

  def storage
    @storage ||= RailsPerformance::Storage::RedisStore.new(url: ENV["REDIS_URL"].presence || "redis://127.0.0.1:6379/1")
  end

  test "accepts redis client" do
    redis = Redis.new(url: ENV["REDIS_URL"].presence || "redis://127.0.0.1:6379/1")

    assert_same redis, RailsPerformance::Storage::RedisStore.new(redis: redis).redis
  end

  test "sets expiration" do
    storage.write("trace|ttl|END|#{RailsPerformance::SCHEMA}", "[]", expires_in: 60)

    assert_in_delta 60, storage.redis.ttl("trace|ttl|END|#{RailsPerformance::SCHEMA}"), 2
  end
end
