require "test_helper"

class RailsPerformance::BaseRecord < ActiveSupport::TestCase
  test "ms" do
    record = RailsPerformance::Models::BaseRecord.new

    assert_equal record.send(:ms, 1), "1.0 ms"
  end
end
