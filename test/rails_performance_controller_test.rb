require 'test_helper'

class RailsPerformanceControllerTest < ActionDispatch::IntegrationTest
  test "should get home page" do
    setup_db
    get '/'
    assert_response :success
  end

  test "should get index" do
    setup_db
    get '/rails/performance'
    assert_response :success
  end

  test "should get index with params" do
    setup_db
    get '/rails/performance', params: { controller_eq: "Home", action_eq: 'index' }
    assert_response :success
  end

  test "should get summary with params" do
    setup_db
    get '/rails/performance/summary', params: { controller_eq: "Home", action_eq: 'index' }, xhr: true
    assert_response :success

    get '/rails/performance/summary', params: { controller_eq: "Home", action_eq: 'index' }, xhr: false
    assert_response :success
  end

  test "should get crashes with params" do
    setup_db
    get '/rails/performance/crashes'
    assert_response :success
  end

  test "should get requests with params" do
    setup_db
    get '/rails/performance/requests'
    assert_response :success
  end

  test "should get recent with params" do
    setup_db
    get '/rails/performance/recent'
    assert_response :success
  end

  test "should get trace with params" do
    setup_db
    get '/rails/performance/trace/123', xhr: true
    assert_response :success

    get '/rails/performance/trace/123', xhr: false
    assert_response :success
  end
end