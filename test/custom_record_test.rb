require "test_helper"

class CustomRecordTest < ActiveSupport::TestCase
  test "custom record storage" do
    result = RailsPerformance.measure "x", "y" do
      40 + 2
    end
    assert_equal 42, result
  end

  test "custom record storage with error" do
    assert_raise(ZeroDivisionError) {
      RailsPerformance.measure "x", "y" do
        42 / 0
      end
    }
  end

  test "custom record test" do
    RailsPerformance.duration = 3.hours

    key = "custom|tag_name|a|namespace_name|b|datetime|20210418T0022|datetimei|1618730556|status|success|END"
    value = '{"duration":0.000221818}'

    record = RailsPerformance::Models::CustomRecord.from_db(key, value)
    assert_equal record.tag_name, "a"
    assert_equal record.namespace_name, "b"
    assert_equal record.datetime, "20210418T0022"
    assert_equal record.datetimei, 1618730556
    assert_equal record.status, "success"
    assert_equal record.value["duration"], 0.000221818
  end
end
