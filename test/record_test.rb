require 'test_helper'

class RecordTest < ActiveSupport::TestCase

  test "storing" do
    record = dummy_event
    assert RailsPerformance::Utils.log_in_redis(record)
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key    = 'performance|controller|HomeController|action|index|format|html|status|200|datetime|20200124T0531|datetimei|1579861868|method|GET|path|/|END'
    value  = '{"view_runtime":15.35346795571968,"db_runtime":0,"duration":17.105664}'

    record = RP::Models::Record.new(key, value)
    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_equal record.value["duration"], 17.105664

    record = RP::Models::Record.new(key, nil)
    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_nil record.value["duration"]
  end
end