# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

def dummy_event
  t = Time.now
  {
    controller: "Home",
    action: "index",
    format: "html",
    status: 200,
    datetime: t.strftime(RailsPerformance::MetricsCollector::FORMAT),
    datetimei: t.to_i,
    method: "GET",
    path: "/",
    view_runtime: 100,
    db_runtime: 50,
    duration: 150
  }
end

def setup_db
  RailsPerformance::Utils.log_in_redis(dummy_event)
end