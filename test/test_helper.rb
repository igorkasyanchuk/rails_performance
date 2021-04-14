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

def dummy_event(time: Time.now, controller: "Home", action: "index", status: 200, path: '/', method: "GET", request_id: SecureRandom.hex(16))
  RailsPerformance::Models::RequestRecord.new(
    controller: controller,
    action: action,
    format: "html",
    status: status,
    datetime: time.strftime(RailsPerformance::FORMAT),
    datetimei: time.to_i,
    method: method,
    path: path,
    view_runtime: rand(100.0),
    db_runtime: rand(100.0),
    duration: 100 + rand(100.0),
    request_id: request_id
  )
end

def dummy_job_event(worker: 'Worker', queue: 'default', jid: "jxzet-#{Time.now.to_i}", created_ati: Time.now.to_i, enqueued_ati: Time.now.to_i, start_timei: Time.now.to_i, duration: rand(60), status: 'success')
  RailsPerformance::Models::JobRecord.new(
    queue: queue,
    worker: worker,
    jid: jid,
    created_ati: created_ati,
    enqueued_ati: enqueued_ati,
    datetime: Time.at(created_ati).strftime(RailsPerformance::FORMAT),
    start_timei: start_timei,
    duration: duration,
    status: status,
  )
end

def dummy_grape_record(created_ati: Time.now.to_i, status: 200, format: "json", method: "GET", path: "/api/users")
  {
    path: path,
    method: method,
    format: format,
    status: status,
    created_ati: created_ati,
    datetime: Time.at(created_ati).strftime(RailsPerformance::FORMAT),
    "endpoint_render.grape" => rand(1.0),
    "endpoint_run.grape" => rand(1.0),
    "format_response.grape" => rand(1.0),
  }
end

def reset_redis
  RP.redis.redis.flushall
end

def setup_db(event = dummy_event)
  event.save
end

def setup_job_db(event = dummy_job_event)
  event.save
end
