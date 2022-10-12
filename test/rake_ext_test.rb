require 'test_helper'

class RakeExtTest < ActiveSupport::TestCase
  test "can exclude rake tasks" do
    skip "This test doesn't work because of circular ref in RakeExt"
    mock_app = Minitest::Mock.new
    mock_app.expect(:current_scope, "test")

    RailsPerformance.skipable_rake_tasks = ["skip_this"]
    RailsPerformance::Gems::RakeExt.init

    subject = Rake::Task.new("skip_this", mock_app)
    subject.invoke({})
  end
end
