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
    setup_db
    ds = RP::DataSource.new(q: {})
    assert_not_nil ds.db
  end

  test "report RequestsReport - ControllerActionReport and group" do
    setup_db

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action_format).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action_format, sort: :db_runtime_slowest).data
  end

  test "report ThroughputReport" do
    setup_db

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::Reports::ThroughputReport.new(ds.db).data
  end

  test "report ResponseTimeReport" do
    setup_db

    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::Reports::ResponseTimeReport.new(ds.db).data
  end

end