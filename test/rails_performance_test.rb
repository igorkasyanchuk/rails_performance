require 'test_helper'

class RailsPerformance::Test < ActiveSupport::TestCase

  test "datastore" do
    setup_db
    ds = RP::DataSource.new(q: {}, type: :requests, klass: RP::Models::RequestRecord)
    assert_not_nil ds.db
  end

  test "report RequestsReport - ControllerActionReport and group" do
    setup_db

    ds = RP::DataSource.new(q: {}, type: :requests, klass: RP::Models::RequestRecord)
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action_format).data
    assert_not_nil RP::Reports::RequestsReport.new(ds.db, group: :controller_action_format, sort: :db_runtime_slowest).data
  end

  test "report ThroughputReport" do
    setup_db

    ds = RP::DataSource.new(q: {}, type: :requests, klass: RP::Models::RequestRecord)
    assert_not_nil RP::Reports::ThroughputReport.new(ds.db).data
  end

  test "report ResponseTimeReport" do
    setup_db

    ds = RP::DataSource.new(q: {}, type: :requests, klass: RP::Models::RequestRecord)
    assert_not_nil RP::Reports::ResponseTimeReport.new(ds.db).data
  end

  test "report TraceReport" do
    setup_db(dummy_event(request_id: "112233"))

    RailsPerformance::Models::TraceRecord.new(request_id: "112233", value: [{x: 1}, {y: 2}]).save
    assert_equal RP::Reports::TraceReport.new(request_id: "112233").data, [{"x" => 1}, {"y" => 2}]
  end

end