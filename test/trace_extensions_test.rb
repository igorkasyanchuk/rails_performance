require "test_helper"

class TraceExtensionsTest < ActiveSupport::TestCase
  class FakeLogSubscriber
    attr_reader :received_event

    def sql(event)
      @received_event = event
    end
  end

  class NotificationsLogSubscriber < FakeLogSubscriber
    prepend RailsPerformance::Extensions::Db
  end

  class StructuredLogSubscriber < FakeLogSubscriber
    prepend RailsPerformance::Extensions::StructuredDb
  end

  setup do
    RailsPerformance::CurrentRequest.cleanup
  end

  teardown do
    RailsPerformance::CurrentRequest.cleanup
  end

  test "Db traces a Notifications event and calls super" do
    subscriber = NotificationsLogSubscriber.new
    event = ActiveSupport::Notifications::Event.new("sql.active_record", 0, 0.0125, "1", {sql: "SELECT 1"})

    subscriber.sql(event)

    tracing = RailsPerformance::CurrentRequest.current.tracings.sole
    assert_equal({group: :db, duration: 12.5, sql: "SELECT 1"}, tracing.except(:time))
    assert_same event, subscriber.received_event
  end

  test "StructuredDb traces a Hash event and calls super" do
    subscriber = StructuredLogSubscriber.new
    event = {name: "active_record.sql", payload: {sql: "SELECT 1", duration_ms: 12.5}}

    subscriber.sql(event)

    tracing = RailsPerformance::CurrentRequest.current.tracings.sole
    assert_equal({group: :db, duration: 12.5, sql: "SELECT 1"}, tracing.except(:time))
    assert_same event, subscriber.received_event
  end

  test "a real query is traced through ActiveRecord::LogSubscriber" do
    ActiveRecord::Base.connection.select_value("SELECT 1")

    tracings = RailsPerformance::CurrentRequest.current.tracings
    assert(tracings.any? { |tracing| tracing[:group] == :db && tracing[:sql] == "SELECT 1" })
  end
end
