require 'test_helper'

class RecordTest < ActiveSupport::TestCase

  test "storing" do
    record = dummy_event
    record.save
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key    = 'performance|controller|HomeController|action|index|format|html|status|200|datetime|20200124T0531|datetimei|1579861868|method|GET|path|/|request_id|1fb7f6c4d874e10644e1259ac44b514e|END'
    value  = '{"view_runtime":15.35346795571968,"db_runtime":0,"duration":17.105664}'

    record = RP::Models::RequestRecord.from_db(key, value)
    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_equal record.value["duration"], 17.105664
    assert_equal record.request_id, "1fb7f6c4d874e10644e1259ac44b514e"

    record = RP::Models::RequestRecord.from_db(key, nil)
    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_nil record.value["duration"]
  end
end