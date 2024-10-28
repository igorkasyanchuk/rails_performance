require "test_helper"
require "csv"

module RailsPerformance
  class CsvExportableTest < ActiveSupport::TestCase
    class MockController < ActionController::Base
      include RailsPerformance::Concerns::CsvExportable
    end

    setup do
      @mock_controller = MockController.new
      @data = [
        {datetime: "2024-10-25 12:00:00",
         controller_action: "TestController#show",
         method: "GET",
         format: "html",
         path: "/test_path",
         status: 200,
         duration: 123.45,
         views: 67.89,
         db: 12.34},
        {
          datetime: "2024-10-25 12:01:00",
          controller_action: "TestController#edit",
          method: "POST",
          format: "json",
          path: "/test_path",
          status: 201, duration:
          543.21,
          views: 45.67,
          db: 8.90
        }
      ]
      @headers = ["datetime", "controller_action", "method", "format", "path",
        "status", "duration", "views", "db"]
    end

    test "generate_csv returns valid CSV content" do
      csv_content = @mock_controller.send(:generate_csv, @data)
      parsed_csv = CSV.parse(csv_content, headers: true)

      assert_equal @headers, parsed_csv.headers

      assert_equal 2, parsed_csv.size
      assert_equal "2024-10-25 12:00:00", parsed_csv[0]["datetime"]
      assert_equal "TestController#show", parsed_csv[0]["controller_action"]
      assert_equal "GET", parsed_csv[0]["method"]
      assert_equal "123.45", parsed_csv[0]["duration"]
    end

    test "export_to_csv does nothing when data is empty" do
      empty_data = []

      @mock_controller.stub(:send_data, nil) do
        assert_nil @mock_controller.export_to_csv("empty_test", empty_data)
      end
    end
  end
end
