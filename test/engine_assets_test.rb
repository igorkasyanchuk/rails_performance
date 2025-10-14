require "test_helper"

class EngineAssetsTest < ActionDispatch::IntegrationTest
  test "should serve JavaScript asset" do
    get "/rails/performance/assets/application.js"
    assert_response :success
    assert_equal response.content_type, "application/javascript"
    assert_includes response.body, "import"
  end

  test "should serve CSS asset" do
    get "/rails/performance/assets/style.css"
    assert_response :success
    assert_equal response.content_type, "text/css"
    assert_includes response.body, "width:"
  end

  test "should return 404 for absolute path attempt" do
    absolute_path = Rails.root.join("app/javascript/packs/application.js").to_s
    assert File.exist?(absolute_path)
    get "/rails/performance/assets#{absolute_path}"
    assert_response :not_found
  end

  test "should return 404 for path traversal attempt" do
    relative_path = "../../../test/dummy/app/javascript/packs/application.js"
    fs_path = File.expand_path(__dir__, "../app/engine_assets/javascripts/#{relative_path}")
    assert File.exist?(fs_path)
    get "/rails/performance/assets/#{relative_path}"
    assert_response :not_found
  end
end
