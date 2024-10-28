require "test_helper"
require "rake"

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"
require "rake/testtask"
require_relative "../lib/rails_performance/gems/rake_ext"

RailsPerformance::Gems::RakeExt.init

class RakeExtTest < ActiveSupport::TestCase
  # this test works only when runing "bundle exec rake test"
  test "can exclude rake tasks" do
    RailsPerformance.skipable_rake_tasks = ["db:version"]
    count_before = count_records_in_redis
    subject = Rake::Task["db:version"]
    subject.invoke({})
    assert_equal count_before, count_records_in_redis

    RailsPerformance.skipable_rake_tasks = []
    count_before = count_records_in_redis
    subject = Rake::Task["db:version"]
    subject.invoke({})
    assert_equal count_before + 1, count_records_in_redis
  end

  def count_records_in_redis
    datasource = RailsPerformance::DataSource.new(q: {}, type: :rake)
    db = datasource.db
    RailsPerformance::Reports::RecentRequestsReport.new(db).data.size
  end
end
