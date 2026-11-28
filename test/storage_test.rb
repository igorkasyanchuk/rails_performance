require "test_helper"
require "redis"

class StorageTest < ActiveSupport::TestCase
  setup do
    @previous_storage = RailsPerformance.storage
  end

  teardown do
    RailsPerformance.storage = @previous_storage
  end

  test "looks up store by name" do
    RailsPerformance.storage = :active_record_store, {database: :performance, cleanup_every: 10}

    assert_instance_of RailsPerformance::Storage::ActiveRecordStore, RailsPerformance.storage
    assert_equal :performance, RailsPerformance.storage.database
    assert_equal 10, RailsPerformance.storage.cleanup_every
  end

  test "looks up store by name without options" do
    RailsPerformance.storage = :active_record_store

    assert_instance_of RailsPerformance::Storage::ActiveRecordStore, RailsPerformance.storage
  end

  test "accepts store instance" do
    store = RailsPerformance::Storage::ActiveRecordStore.new
    RailsPerformance.storage = store

    assert_same store, RailsPerformance.storage
  end

  test "uses redis by default" do
    assert_instance_of RailsPerformance::Storage::RedisStore, RailsPerformance::Storage.lookup_store
  end

  test "config.redis= is deprecated" do
    redis = Redis.new

    assert_deprecated(/config.redis= is deprecated/, RailsPerformance.deprecator) do
      RailsPerformance.redis = redis
    end
    assert_same redis, RailsPerformance.storage.redis

    assert_deprecated(/RailsPerformance.redis is deprecated/, RailsPerformance.deprecator) do
      assert_same redis, RailsPerformance.redis
    end
  end

  test "RailsPerformance.redis is nil for non-redis storage" do
    RailsPerformance.storage = :active_record_store

    assert_deprecated(/RailsPerformance.redis is deprecated/, RailsPerformance.deprecator) do
      assert_nil RailsPerformance.redis
    end
  end
end
