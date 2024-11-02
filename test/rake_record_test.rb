require "test_helper"

class RakeRecordTest < ActiveSupport::TestCase
  test "rake_record" do
    RailsPerformance.duration = 3.hours

    key = 'rake|task|["task3"]|datetime|20210416T1254|datetimei|1618602843|status|error|END'
    value = '{"duration":0.00012442}'

    record = RailsPerformance::Models::RakeRecord.from_db(key, value)
    assert_equal record.task, ["task3"]
    assert_equal record.datetime, "20210416T1254"
    assert_equal record.datetimei, 1618602843
    assert_equal record.status, "error"
    assert_equal record.value["duration"], 0.00012442
  end
end
