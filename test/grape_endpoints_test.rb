require "test_helper"

class GrapeEndpointsTest < ActionDispatch::IntegrationTest
  def grape_count
    ds = RailsPerformance::DataSource.new(type: :grape)
    ds.db.data.size
  end

  def grape_records
    ds = RailsPerformance::DataSource.new(type: :grape)
    ds.db.data
  end

  setup do
    reset_redis
  end

  test "logs successful 200 response with correct data" do
    assert_equal 0, grape_count
    get "/api/users"
    assert_response :success
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/users", record.path
    assert_equal "GET", record.method
    assert_equal "200", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # Check that timing values are recorded
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
    assert_not_nil record.value["format_response.grape"]
  end

  test "logs 204 no content with content response with correct data" do
    assert_equal 0, grape_count
    get "/api/no_content_with_content"
    assert_response :no_content
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/no_content_with_content", record.path
    assert_equal "GET", record.method
    assert_equal "204", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # For no-content responses, format_response.grape might be nil
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
    # format_response.grape might be nil for 204 responses
  end

  test "logs 204 no content response with correct data" do
    assert_equal 0, grape_count
    get "/api/no_content"
    assert_response :no_content
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/no_content", record.path
    assert_equal "GET", record.method
    assert_equal "204", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # For no-content responses, format_response.grape might be nil
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
    # format_response.grape might be nil for 204 responses
  end

  test "logs 409 conflict response with correct data" do
    assert_equal 0, grape_count
    get "/api/conflict"
    assert_response :conflict
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/conflict", record.path
    assert_equal "GET", record.method
    assert_equal "409", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # Check timing values
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
  end

  test "logs 422 unprocessable entity response with correct data" do
    assert_equal 0, grape_count
    get "/api/unprocessable_entity"
    assert_response :unprocessable_content
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/unprocessable_entity", record.path
    assert_equal "GET", record.method
    assert_equal "422", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # Check timing values
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
  end

  test "logs 500 internal server error response with correct data" do
    assert_equal 0, grape_count
    get "/api/internal_server_error"
    assert_response :internal_server_error
    assert_equal 1, grape_count

    record = grape_records.first
    assert_equal "json", record.format
    assert_equal "/api/internal_server_error", record.path
    assert_equal "GET", record.method
    assert_equal "500", record.status
    assert_not_nil record.request_id
    assert_not_nil record.datetime
    assert_not_nil record.datetimei

    # Check timing values
    assert_not_nil record.value["endpoint_render.grape"]
    assert_not_nil record.value["endpoint_run.grape"]
  end
end
