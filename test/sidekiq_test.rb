require "test_helper"

class SidekiqTest < ActiveSupport::TestCase
  test "works" do
    SimpleWorker.new.perform

    s = RailsPerformance::Gems::SidekiqExt.new
    res = s.call("worker", "msg", -> {}) do
      40 + 2
    end

    assert_equal 42, res
  end
end
