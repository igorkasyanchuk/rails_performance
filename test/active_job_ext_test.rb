require 'test_helper'

class ActiveJobExtTest < ActiveSupport::TestCase
  test "storing" do
    record = dummy_active_job_event
    record.save
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key   = "active_job|queue|default|worker|SimpleWorker|jid|7d48fbf20976c224510dbc60|datetime|1583146613|datetimei|1583146614|enqueued_ati|1583146615|start_timei|1583146616|status|success|END|#{RailsPerformance::Models::ActiveJobRecord::SCHEMA}"

    value  = '{"duration": 123, "message":"hello"}'

    record = RailsPerformance::Models::ActiveJobRecord.from_db(key, value)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_equal record.value["message"], 'hello'
    assert_equal record.value["duration"], 123
    assert_equal record.jid, "7d48fbf20976c224510dbc60"
    assert_equal record.datetimei, 1583146614

    record = RailsPerformance::Models::ActiveJobRecord.from_db(key, nil)
    assert_equal record.queue, "default"
    assert_equal record.worker, "SimpleWorker"
    assert_nil record.value["message"]
  end

  test "performs" do
    RailsPerformance.duration = 3.hours

    begin
      MyJob.perform_now
    rescue => e
    end

    @datasource = RailsPerformance::DataSource.new(q: {}, type: :jobs)
    db = @datasource.db

    assert db.data.size > 0
  end
end
