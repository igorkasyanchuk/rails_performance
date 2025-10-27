# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "simplecov"
require "minitest/autorun"

SimpleCov.start do
  add_filter "test/dummy"
end

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  # ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  # ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  # ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  # ActiveSupport::TestCase.fixtures :all
end

def dummy_event(time: RailsPerformance::Utils.time, controller: "Home", action: "index", status: 200, path: "/", method: "GET", request_id: SecureRandom.hex(16))
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

def dummy_sidekiq_event(worker: "Worker", queue: "default", jid: "jxzet-#{RailsPerformance::Utils.time.to_i}", datetimei: RailsPerformance::Utils.time.to_i, enqueued_ati: RailsPerformance::Utils.time.to_i, start_timei: RailsPerformance::Utils.time.to_i, duration: rand(60), status: "success")
  RailsPerformance::Models::SidekiqRecord.new(
    queue: queue,
    worker: worker,
    jid: jid,
    datetimei: datetimei,
    enqueued_ati: enqueued_ati,
    datetime: RailsPerformance::Utils.from_datetimei(datetimei).strftime(RailsPerformance::FORMAT),
    start_timei: start_timei,
    duration: duration,
    status: status
  )
end

def dummy_grape_record(datetimei: RailsPerformance::Utils.time.to_i, status: 200, format: "json", method: "GET", path: "/api/users", request_id: SecureRandom.hex(16))
  RailsPerformance::Models::GrapeRecord.new(
    path: path,
    method: method,
    format: format,
    status: status,
    datetimei: datetimei,
    datetime: RailsPerformance::Utils.from_datetimei(datetimei).strftime(RailsPerformance::FORMAT),
    endpoint_render_grape: rand(10),
    endpoint_run_grape: rand(10),
    format_response_grape: rand(10),
    request_id: request_id
  )
end

def dummy_rake_record(datetimei: RailsPerformance::Utils.time.to_i, status: "success", task: "x111111111#{rand(10000000)}")
  RailsPerformance::Models::RakeRecord.new(
    task: task,
    datetime: RailsPerformance::Utils.from_datetimei(datetimei).strftime(RailsPerformance::FORMAT),
    datetimei: datetimei,
    status: "success",
    json: '{"duration": 100}'
  )
end

def dummy_delayed_job_record(datetimei: RailsPerformance::Utils.time.to_i, status: "success", jid: "x111111111#{rand(10000000)}")
  RailsPerformance::Models::DelayedJobRecord.new(
    jid: jid,
    datetime: RailsPerformance::Utils.from_datetimei(datetimei).strftime(RailsPerformance::FORMAT),
    datetimei: datetimei,
    source_type: "instance_method",
    class_name: "User",
    method_name: "hell_world",
    status: status,
    json: '{"duration": 100}'
  )
end

def reset_redis
  RailsPerformance.redis.flushdb
end

# TODO improve

def setup_db(event = dummy_event)
  event.save
end

def setup_sidekiq_db(event = dummy_sidekiq_event)
  event.save
end

def setup_rake_db(event = dummy_rake_record)
  event.save
end

def setup_delayed_job_db(event = dummy_delayed_job_record)
  event.save
end

def setup_grape_db(event = dummy_grape_record)
  event.save
end

# created_ati = RailsPerformance::Utils.time.to_i
# RailsPerformance::Models::RakeRecord.new(
#   task: 'task',
#   datetime: RailsPerformance::Utils.from_datetimei(created_ati).strftime(RailsPerformance::FORMAT),
#   datetimei: created_ati,
#   status: 'success',
#   json: '{"duration": 100}'
# ).save
