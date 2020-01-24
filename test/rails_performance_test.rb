require 'test_helper'

class RailsPerformance::Test < ActiveSupport::TestCase

  test "storing" do
    record = dummy_event
    assert RailsPerformance::Utils.log_in_redis(record)
  end

  test "record" do
    key    = 'performance|controller|HomeController|action|index|format|html|status|200|datetime|20200124T0531|datetimei|1579861868|method|GET|path|/|END'
    value  = '{"view_runtime":15.35346795571968,"db_runtime":0,"duration":17.105664}'
    record = RP::Record.new(key, value)

    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_equal record.value["duration"], 17.105664
  end

  test "datastore" do
    RailsPerformance::Utils.log_in_redis(dummy_event)

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::DataSource.all
    assert_not_nil ds.db
  end

  test "report ControllerActionReport" do
    RailsPerformance::Utils.log_in_redis(dummy_event)

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::RequestsReport.new(ds.db, group: :controller_action).data
  end

  test "report ThroughputReport" do
    RailsPerformance::Utils.log_in_redis(dummy_event)

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::ThroughputReport.new(ds.db).data
  end

end

def dummy_event
  t = Time.now
  {
    controller: "Home",
    action: "index",
    format: "html",
    status: 200,
    datetime: t.strftime(RailsPerformance::MetricsListener::FORMAT),
    datetimei: t.to_i,
    method: "GET",
    path: "/",
    view_runtime: 100,
    db_runtime: 50,
    duration: 150
  }
end
