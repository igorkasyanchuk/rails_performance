require "test_helper"

class RailsPerformance::EventsTest < ActiveSupport::TestCase
  test "create_event" do
    assert_nothing_raised do
      RailsPerformance.create_event(name: "test", options: {
        borderColor: "#00E396",
        label: {
          borderColor: "#00E396",
          orientation: "horizontal",
          text: "test"
        }
      })
    end

    events = RailsPerformance::Events::Record.all
    assert_equal events.size, 1
    assert_equal events.first.name, "test"
    assert_equal events.first.options, {
      borderColor: "#00E396",
      label: {
        borderColor: "#00E396",
        orientation: "horizontal",
        text: "test"
      }
    }.deep_stringify_keys
  end
end
