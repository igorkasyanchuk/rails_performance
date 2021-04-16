require 'test_helper'

class DelayedJobRecordTest < ActiveSupport::TestCase

  test "delayed job record" do
    RailsPerformance.duration = 3.hours

    key    = 'delayed_job|jid|24|datetime|20210416T1304|datetimei|1618603467|source_type|class_method|class_name|User|method_name|xxx|status|success|END '
    value  = '{"duration":0.000221818}'

    record = RP::Models::DelayedJobRecord.from_db(key, value)
    assert_equal record.jid, "24"
    assert_equal record.datetime, "20210416T1304"
    assert_equal record.source_type, "class_method"
    assert_equal record.class_name, "User"
    assert_equal record.method_name, "xxx"
    assert_equal record.value['duration'], 0.000221818
  end
end