require "redis"
require "redis-namespace"
require_relative "./rails_performance/version.rb"
require_relative "rails_performance/rails/query_builder.rb"
require_relative "rails_performance/rails/middleware.rb"
require_relative "rails_performance/data_source.rb"
require_relative "rails_performance/models/base_record.rb"
require_relative "rails_performance/models/record.rb"
require_relative "rails_performance/models/job_record.rb"
require_relative "rails_performance/utils.rb"
require_relative "rails_performance/reports/base_report.rb"
require_relative "rails_performance/reports/requests_report.rb"
require_relative "rails_performance/reports/crash_report.rb"
require_relative "rails_performance/reports/response_time_report.rb"
require_relative "rails_performance/reports/throughput_report.rb"
require_relative "rails_performance/reports/recent_requests_report.rb"
require_relative "rails_performance/reports/breakdown_report.rb"
require_relative "rails_performance/reports/trace_report.rb"
require_relative "rails_performance/extensions/capture_everything.rb"
require_relative "rails_performance/models/current_request.rb"

module RailsPerformance
  FORMAT = "%Y%m%dT%H%M"

  mattr_accessor :redis
  @@redis = Redis::Namespace.new("#{::Rails.env}-rails-performance", redis: Redis.new)

  mattr_accessor :duration
  @@duration = 4.hours

  mattr_accessor :debug
  @@debug = false

  mattr_accessor :enabled
  @@enabled = true

  # default path where to mount gem
  mattr_accessor :mount_at
  @@mount_at = "/rails/performance"

  # Enable http basic authentication
  mattr_accessor :http_basic_authentication_enabled
  @@http_basic_authentication_enabled = false

  # Enable http basic authentication
  mattr_accessor :http_basic_authentication_user_name
  @@http_basic_authentication_user_name = 'rails_performance'

  # Enable http basic authentication
  mattr_accessor :http_basic_authentication_password
  @@http_basic_authentication_password = 'password12'

  # If you want to enable access by specific conditions
  mattr_accessor :verify_access_proc
  @@verify_access_proc = proc { |controller| true }

  mattr_reader :ignored_endpoints
  def RailsPerformance.ignored_endpoints=(endpoints)
    @@ignored_endpoints = Set.new(endpoints)
  end
  @@ignored_endpoints = []

  def self.setup
    yield(self)
  end

end

RP = RailsPerformance

require "rails_performance/engine"
