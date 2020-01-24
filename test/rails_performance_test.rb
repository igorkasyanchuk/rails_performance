require 'test_helper'

class RailsPerformance::Test < ActiveSupport::TestCase
  test "record" do
    key   = 'performance|controller|HomeController|action|index|format|html|status|200|datetime|20200124T0531|datetimei|1579861868|method|GET|path|/|duration'
    value = '{"view_runtime":15.35346795571968,"db_runtime":0,"duration":17.105664}'
    record = RailsPerformance::Record.new(key, value)

    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_equal record.value["duration"], 17.105664
  end

  test "datastore" do
    ds = RailsPerformance::DataSource.new(q: {})
    assert_not_nil RailsPerformance::DataSource.all
    assert_not_nil ds.collection
  end

  test "report ThroughputReport" do
    ds = RailsPerformance::DataSource.new(q: {})
    assert_not_nil RailsPerformance::ThroughputReport.new(ds).data
  end

  test "report GlobalReport" do
    ds = RailsPerformance::DataSource.new(q: {})
    assert_not_nil RailsPerformance::GlobalReport.new(ds, group: :controller_action).data
  end

end
