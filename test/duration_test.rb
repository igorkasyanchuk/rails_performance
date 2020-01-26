require 'test_helper'

class RailsPerformance::Test1 < ActiveSupport::TestCase

  test 'duration' do
    RailsPerformance.duration = 24.hours

    @datasource = RailsPerformance::DataSource.new()
    @data       = RailsPerformance::ThroughputReport.new(@datasource.db).data

    assert_equal @data.size / 60, 24
  end

end

