# frozen_string_literal: true

require "test_helper"

class JbuilderCompatibilityTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(first_name: "John", age: 30)

    get users_path(format: :json)
  end

  test "endpoint returns valid JSON" do
    assert_response :success
    assert_equal "application/json", response.media_type

    body = response.parsed_body
    assert_kind_of Hash, body

    expected = {
      "home" => root_url,
      "users" => [@user.as_json(only: %i[id first_name age email])]
    }

    assert_equal expected, body
  end
end
