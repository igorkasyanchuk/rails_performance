require "test_helper"

class RailsPerformanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    reset_redis
    RailsPerformance.skip = false
    User.create(first_name: "John", age: 20)
  end

  def requests_report_data
    source = RailsPerformance::DataSource.new(type: :requests)
    RailsPerformance::Reports::RequestsReport.new(source.db, group: :controller_action_format).data
  end

  test "should get home page" do
    assert_equal requests_report_data.size, 0
    setup_db
    assert_equal requests_report_data.size, 1
    get "/"
    assert_equal requests_report_data.size, 2
    assert_response :success
  end

  test "should respect ignored_endpoints configuration value" do
    assert_equal requests_report_data.size, 0
    get "/home/contact"
    assert_equal requests_report_data.size, 1
    assert_equal requests_report_data.first[:group], "HomeController#contact|html"
    reset_redis
    assert_equal requests_report_data.size, 0

    original_ignored_endpoints = RailsPerformance.ignored_endpoints
    RailsPerformance.ignored_endpoints = ["HomeController#contact"]
    get "/home/contact"
    assert_equal requests_report_data.size, 0
    RailsPerformance.ignored_endpoints = original_ignored_endpoints
  end

  test "should respect ignored_paths configuration value" do
    original_ignored_paths = RailsPerformance.ignored_paths
    RailsPerformance.ignored_paths = ["/home"]
    get "/home/contact"
    assert_equal requests_report_data.size, 0
    RailsPerformance.ignored_paths = original_ignored_paths
  end

  test "should get index" do
    setup_db
    assert_equal requests_report_data.size, 1
    get "/rails/performance"
    # make sure rails/performance paths are ignored
    assert_equal requests_report_data.size, 1
    assert_response :success
  end

  test "should get index with params" do
    setup_db
    get "/rails/performance", params: {controller_eq: "Home", action_eq: "index"}
    assert_response :success
  end

  test "should get summary with params" do
    setup_db
    get "/rails/performance/summary", params: {controller_eq: "Home", action_eq: "index"}, xhr: true
    assert_response :success

    get "/rails/performance/summary", params: {controller_eq: "Home", action_eq: "index"}, xhr: false
    assert_response :success
  end

  test "should get home pages" do
    get "/home/about"
    assert_response :success
    get "/home/blog"
    assert_response :success
  end

  test "should get about page" do
    get "/account/site/about"
    assert_response :success
  end

  test "should get account other pages" do
    get "/account/site/not_found"
    assert_response :not_found

    get "/account/site/is_redirect"
    assert_response :redirect
  end

  test "should get crashes with params" do
    begin
      get "/account/site/crash"
    rescue
    end

    get "/rails/performance/crashes"
    assert_response :success
    assert response.body.include?("Account::SiteController")
  end

  test "should get requests with params" do
    setup_db
    get "/rails/performance/requests"
    assert_response :success
  end

  test "should get recent with params" do
    setup_db
    get "/rails/performance/recent"
    assert_response :success

    get "/rails/performance/recent", xhr: true
    assert_response :success
  end

  test "should get slow with params" do
    setup_db
    get "/rails/performance/slow"
    assert_response :success
  end

  test "should get sidekiq with params" do
    setup_db
    setup_sidekiq_db
    get "/rails/performance/sidekiq"
    assert_response :success
  end

  test "should get delayed_job with params" do
    setup_db
    setup_sidekiq_db
    get "/rails/performance/delayed_job"
    assert_response :success
  end

  test "should get rake" do
    setup_db
    setup_rake_db
    get "/rails/performance/rake"
    assert_response :success
  end

  test "should get custom" do
    setup_db
    get "/"
    get "/rails/performance/custom"
    assert_response :success
  end

  test "should get grape page" do
    setup_db
    setup_grape_db
    get "/api/users"
    get "/api/ping"
    get "/api/crash"
    get "/rails/performance/grape"
    assert_response :success
  end

  test "resources tab" do
    setup_db

    RailsPerformance::Extensions::ResourceMonitor.new("rails", "web123").run

    get "/rails/performance/resources"
    assert_response :success
    assert response.body.include?("web123")
  end

  test "should get trace with params" do
    setup_db(dummy_event(request_id: "112233"))
    RailsPerformance::Models::TraceRecord.new(request_id: "112233", value: [
      {group: :db, sql: "select", duration: 111},
      {group: :view, message: "rendering (Duration: 11.3ms)"}
    ]).save

    get "/rails/performance/trace/112233", xhr: true
    assert_response :success

    get "/rails/performance/trace/112233", xhr: false
    assert_response :success
  end
end
