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

def reset_storage
  RailsPerformance.storage.clear
end

# shared tests for storage adapters, the test class must define #storage
module StorageContract
  extend ActiveSupport::Concern

  included do
    setup do
      @previous_storage = RailsPerformance.storage
      RailsPerformance.storage = storage
      storage.clear
    end

    teardown do
      storage.clear
      RailsPerformance.storage = @previous_storage
    end

    test "writes and reads a value" do
      storage.write("trace|abc|END|#{RailsPerformance::SCHEMA}", "[1,2]", expires_in: 60)

      assert_equal "[1,2]", storage.read("trace|abc|END|#{RailsPerformance::SCHEMA}")
      assert_nil storage.read("trace|missing|END|#{RailsPerformance::SCHEMA}")
    end

    test "overwrites a value with the same key" do
      key = storage_request_key(request_id: "same")
      storage.write(key, '{"duration":1}', expires_in: 60)
      storage.write(key, '{"duration":2}', expires_in: 60)

      assert_equal '{"duration":2}', storage.read(key)
      assert_equal [[key], ['{"duration":2}']], storage.fetch("performance|*|request_id|same|*")
    end

    test "fetches values by pattern" do
      home = storage_request_key(controller: "Home", request_id: "1")
      users = storage_request_key(controller: "Users", request_id: "2")
      storage.write(home, '{"duration":1}', expires_in: 60)
      storage.write(users, '{"duration":2}', expires_in: 60)
      date = RailsPerformance::Utils.time.strftime("%Y%m%d")

      keys, values = storage.fetch("performance|*controller|Home|*datetime|#{date}*|*|END|#{RailsPerformance::SCHEMA}")
      assert_equal [home], keys
      assert_equal ['{"duration":1}'], values

      keys, _ = storage.fetch("performance|*datetime|#{date}*|*|END|#{RailsPerformance::SCHEMA}")
      assert_equal [home, users].sort, keys.sort
    end

    test "fetches values by pattern without date" do
      key = storage_request_key(request_id: "xyz")
      storage.write(key, "{}", expires_in: 60)

      assert_equal [[key], ["{}"]], storage.fetch("performance|*|request_id|xyz|*")
    end

    test "returns empty array when nothing found" do
      assert_equal [], storage.fetch("performance|*|request_id|nothing|*")
      assert_equal [], storage.fetch("sidekiq|*|END|#{RailsPerformance::SCHEMA}")
    end

    test "treats special characters in keys literally" do
      key = storage_request_key(path: "/users/100%_done", request_id: "special")
      other = storage_request_key(path: "/users/100xxdone", request_id: "other")
      storage.write(key, "{}", expires_in: 60)
      storage.write(other, "{}", expires_in: 60)

      keys, _ = storage.fetch("performance|*path|/users/100%_done|*")
      assert_equal [key], keys
    end

    test "fetches events" do
      RailsPerformance::Events::Record.create(name: "Deploy")

      assert_equal ["Deploy"], RailsPerformance::Events::Record.all.map(&:name)
    end

    test "clears all values" do
      key = storage_request_key
      storage.write(key, "{}", expires_in: 60)
      storage.clear

      assert_nil storage.read(key)
      assert_equal [], storage.fetch("performance|*")
    end

    test "clears records of every type" do
      setup_db
      setup_sidekiq_db
      setup_rake_db
      setup_delayed_job_db
      setup_grape_db
      RailsPerformance.measure("label") {}
      now = RailsPerformance::Utils.time
      RailsPerformance::Models::ResourceRecord.new(server: "server", context: "rails", role: "web", datetime: now.strftime(RailsPerformance::FORMAT), datetimei: now.to_i, json: {cpu: 1}).save
      RailsPerformance::Events::Record.create(name: "Deploy")

      RailsPerformance::DataSource::KLASSES.each_key do |type|
        assert_not_empty RailsPerformance::DataSource.new(q: {}, type: type).db.data, "#{type} is not stored"
      end

      storage.clear

      RailsPerformance::DataSource::KLASSES.each_key do |type|
        assert_empty RailsPerformance::DataSource.new(q: {}, type: type).db.data, "#{type} is not cleared"
      end
      assert_empty RailsPerformance::Events::Record.all
    end
  end

  def storage_request_key(controller: "Home", path: "/", request_id: SecureRandom.hex(16), time: RailsPerformance::Utils.time)
    "performance|controller|#{controller}|action|index|format|html|status|200|datetime|#{time.strftime(RailsPerformance::FORMAT)}|datetimei|#{time.to_i}|method|GET|path|#{path}|request_id|#{request_id}|END|#{RailsPerformance::SCHEMA}"
  end
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
