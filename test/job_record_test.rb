require 'test_helper'

class JobRecordTest < ActiveSupport::TestCase

  test "storing" do
    record = dummy_job_event
    assert RailsPerformance::Utils.log_job_in_redis(record)
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key    = 'sidekiq-performance|queue|default|worker|SimpleWorker|jid|7d48fbf20976c224510dbc60|created_ati|1583146613|enqueued_ati|1583146613|start_timei|1583146614|duration|14.000650979|status|success|END'
    value  = '{"message":"hello"}'

    record = RP::Models::JobRecord.new(key, value)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_equal record.value["message"], 'hello'
    assert_equal record.jid, "7d48fbf20976c224510dbc60"

    record = RP::Models::JobRecord.new(key, nil)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_nil record.value["message"]
  end
end