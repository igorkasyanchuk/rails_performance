require "test_helper"
require "minitest/mock"

class ActiveRecordStoreTest < ActiveSupport::TestCase
  include StorageContract

  def storage
    @storage ||= RailsPerformance::Storage::ActiveRecordStore.new
  end

  test "skips expired records" do
    key = storage_request_key(request_id: "expired")
    storage.write(key, "{}", expires_in: 60)

    travel 2.minutes do
      assert_nil storage.read(key)
      assert_equal [], storage.fetch("performance|*|request_id|expired|*")
    end
  end

  test "removes expired records on cleanup" do
    storage.write(storage_request_key(request_id: "old"), "{}", expires_in: 60)
    storage.write(storage_request_key(request_id: "new"), "{}", expires_in: 600)

    travel 2.minutes do
      storage.cleanup
    end

    assert_equal 1, storage.model.count
  end

  test "logs write errors instead of raising" do
    missing_table = Class.new(storage.model) { self.table_name = "rails_performance_missing" }

    ActiveRecord::Base.transaction do
      storage.stub(:model, missing_table) do
        assert_nil storage.write(storage_request_key, "{}", expires_in: 60)
      end

      assert_equal 1, ActiveRecord::Base.connection.select_value("SELECT 1")
    end
  end

  test "uses unique_by only when database supports it" do
    assert_equal({unique_by: :key_digest}, storage.send(:upsert_options))

    store = RailsPerformance::Storage::ActiveRecordStore.new
    store.model.connection_pool.with_connection do |connection|
      connection.stub(:supports_insert_conflict_target?, false) do
        assert_equal({}, store.send(:upsert_options))
      end
    end
  end

  test "treats trailing backslash in pattern literally" do
    assert_equal "performance|%\\\\", storage.send(:like_pattern, "performance|*\\")
  end

  test "does not trace own queries" do
    RailsPerformance::CurrentRequest.cleanup

    storage.write("trace|abc|END|#{RailsPerformance::SCHEMA}", "[]", expires_in: 60)
    storage.read("trace|abc|END|#{RailsPerformance::SCHEMA}")
    ActiveRecord::Base.connection.select_value("SELECT 1")

    assert_equal ["SELECT 1"], RailsPerformance::CurrentRequest.current.tracings.map { |e| e[:sql] }
  ensure
    RailsPerformance::CurrentRequest.cleanup
  end
end
