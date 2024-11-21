require "test_helper"

class ResoorcesMonitoringTest < ActiveSupport::TestCase
  test "runs" do
    assert_nothing_raised do
      rm = RailsPerformance::Extensions::ResourceMonitor.new("rails", "web123")
      rm.start_monitoring
      rm.run
      rm.stop_monitoring
    end
  end
end
