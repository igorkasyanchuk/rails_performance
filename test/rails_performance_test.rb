require 'test_helper'

class RailsPerformance::Test < ActiveSupport::TestCase
  test "record" do
    key   = 'performance|controller|HomeController|action|index|format|html|status|200|datetime|20200124T0531|datetimei|1579861868|method|GET|path|/|duration'
    value = '{"view_runtime":15.35346795571968,"db_runtime":0,"duration":17.105664}'
    record = RP::Record.new(key, value)

    assert_equal record.controller, "HomeController"
    assert_equal record.status, "200"
    assert_equal record.value["duration"], 17.105664
  end

  test "datastore" do
    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::DataSource.all
    assert_not_nil ds.collection
  end

  test "report ThroughputReport" do
    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::ThroughputReport.new(ds).data
  end

  test "report GlobalReport" do
    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::GlobalReport.new(ds, group: :controller_action).data
  end

  test "report ThroughputReport2" do
    ds = RP::DataSource.new(q: {})
    assert_not_nil RP::ThroughputReport2.new(ds).data
  end  

end
