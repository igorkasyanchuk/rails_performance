require "test_helper"

class SidekiqRecordTest < ActiveSupport::TestCase
  test "storing" do
    assert_nothing_raised do
      record = dummy_sidekiq_event
      record.save
    end
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key = "sidekiq-performance|queue|default|worker|SimpleWorker|jid|7d48fbf20976c224510dbc60|datetimei|1583146613|enqueued_ati|1583146613|start_timei|1583146614|duration|14.000650979|status|success|END"
    value = '{"message":"hello"}'

    record = RailsPerformance::Models::SidekiqRecord.from_db(key, value)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_equal record.value["message"], "hello"
    assert_equal record.jid, "7d48fbf20976c224510dbc60"
    assert_equal record.datetimei, 1583146613

    record = RailsPerformance::Models::SidekiqRecord.from_db(key, nil)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_nil record.value["message"]
  end
end
