require "test_helper"

class RailsPerformance::Test1 < ActiveSupport::TestCase
  test "duration report" do
    RailsPerformance.duration = 24.hours

    @datasource = RailsPerformance::DataSource.new(type: :requests)
    @data = RailsPerformance::Reports::ThroughputReport.new(@datasource.db).data

    assert_equal @data.size / 60, 24
  end
end
