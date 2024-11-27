require "test_helper"

class GrapeRecordTest < ActiveSupport::TestCase
  test "storing" do
    assert_nothing_raised do
      record = dummy_grape_record
      record.save
    end
  end

  test "record" do
    RailsPerformance.duration = 3.hours

    key = "grape|datetime|20210409T1115|datetimei|1617992134|format|json|path|/api/users|status|200|method|GET|request_id|1122|END"
    value = '{"endpoint_render.grape":0.0001797,"endpoint_run.grape":0.000763125,"format_response.grape":7.1058e-05}'

    record = RailsPerformance::Models::GrapeRecord.from_db(key, value)
    assert_equal record.format, "json"
    assert_equal record.path, "/api/users"
    assert_equal record.method, "GET"
    assert_equal record.status, "200"
    assert_equal record.request_id, "1122"
    assert_equal record.datetime, "20210409T1115"
    assert_equal record.datetimei, 1617992134
    assert_equal record.value["endpoint_render.grape"], 0.0001797
    assert_equal record.value["endpoint_run.grape"], 0.000763125
    assert_equal record.value["format_response.grape"], 7.1058e-05
  end
end
