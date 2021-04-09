require 'test_helper'

class RailsPerformanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    reset_redis
  end

  def requests_report_data
    source = RP::DataSource.new(type: :requests, klass: RP::Models::Record)
    RP::Reports::RequestsReport.new(source.db, group: :controller_action_format).data
  end

  test "should get home page" do
    assert_equal requests_report_data.size, 0
    setup_db
    assert_equal requests_report_data.size, 1
    get '/'
    assert_equal requests_report_data.size, 2
    assert_response :success
  end

  test "should respect ignored_endpoints configuration value" do
    assert_equal requests_report_data.size, 0
    get '/home/contact'
    assert_equal requests_report_data.size, 1
    assert_equal requests_report_data.first[:group], "HomeController#contact|html"
    reset_redis
    assert_equal requests_report_data.size, 0
    
    original_ignored_endpoints = RP.ignored_endpoints
    RP.ignored_endpoints = ['HomeController#contact']
    get '/home/contact'
    assert_equal requests_report_data.size, 0
    RP.ignored_endpoints = original_ignored_endpoints
  end

  test "should get index" do
    setup_db
    assert_equal requests_report_data.size, 1
    get '/rails/performance'
    # make sure rails/performance paths are ignored
    assert_equal requests_report_data.size, 1
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

  test "should get jobs with params" do
    setup_db
    setup_job_db
    get '/rails/performance/jobs'
    assert_response :success
  end

  test "should get grape page" do
    setup_db
    setup_job_db
    get '/api/users'
    get '/api/ping'
    get '/rails/performance/grape'
    assert_response :success
  end

  test "should get trace with params" do
    setup_db(dummy_event(request_id: "112233"))
    RP::Utils.log_trace_in_redis("112233", [
      {group: :db, sql: "select", duration: 111},
      {group: :view, message: "rendering (Duration: 11.3ms)"}
    ])

    get '/rails/performance/trace/112233', xhr: true
    assert_response :success

    get '/rails/performance/trace/112233', xhr: false
    assert_response :success
  end
end
