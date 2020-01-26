require 'test_helper'

class RailsPerformanceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    setup_db

    get '/rails/performance'
    assert_response :success
  end
end