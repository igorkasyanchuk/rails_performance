require "redis"
require "redis-namespace"
require "browser"
require 'active_support/core_ext/integer'
require_relative "./rails_performance/version.rb"
require_relative "rails_performance/rails/query_builder.rb"
require_relative "rails_performance/rails/middleware.rb"
require_relative "rails_performance/models/base_record.rb"
require_relative "rails_performance/models/request_record.rb"
require_relative "rails_performance/models/sidekiq_record.rb"
require_relative "rails_performance/models/delayed_job_record.rb"
require_relative "rails_performance/models/grape_record.rb"
require_relative "rails_performance/models/trace_record.rb"
require_relative "rails_performance/models/rake_record.rb"
require_relative "rails_performance/models/custom_record.rb"
require_relative "rails_performance/data_source.rb"
require_relative "rails_performance/utils.rb"
require_relative "rails_performance/reports/base_report.rb"
require_relative "rails_performance/reports/requests_report.rb"
require_relative "rails_performance/reports/crash_report.rb"
require_relative "rails_performance/reports/response_time_report.rb"
require_relative "rails_performance/reports/throughput_report.rb"
require_relative "rails_performance/reports/recent_requests_report.rb"
require_relative "rails_performance/reports/slow_requests_report.rb"
require_relative "rails_performance/reports/breakdown_report.rb"
require_relative "rails_performance/reports/trace_report.rb"
require_relative "rails_performance/extensions/trace.rb"
require_relative "rails_performance/thread/current_request.rb"

module RailsPerformance
  FORMAT = "%Y%m%dT%H%M"

  mattr_accessor :redis
  @@redis = Redis::Namespace.new("{#{::Rails.env}-rails-performance}", redis: Redis.new)

  mattr_accessor :duration
  @@duration = 4.hours

  mattr_accessor :recent_requests_time_window
  @@recent_requests_time_window = 60.minutes

  mattr_accessor :recent_requests_limit
  @@recent_requests_limit = nil

  mattr_accessor :slow_requests_time_window
  @@slow_requests_time_window = 4.hours

  mattr_accessor :slow_requests_limit
  @@recent_requests_limit = 500

  mattr_accessor :slow_requests_threshold
  @@slow_requests_threshold = 500

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

  # skip requests if it's inside Rails Performance view
  mattr_accessor :skip
  @@skip = false

  # config home button link
  mattr_accessor :home_link
  @@home_link = '/'

  # skip performance tracking for these rake tasks
  mattr_accessor :skipable_rake_tasks
  @@skipable_rake_tasks = []

  # add custom payload to the request
  mattr_accessor :custom_data_proc
  @@custom_data_proc = nil

  # include rake tasks
  mattr_accessor :include_rake_tasks
  @@include_rake_tasks = false

  # include custom events
  mattr_accessor :include_custom_events
  @@include_custom_events = true

  def RailsPerformance.setup
    yield(self)
  end

  def RailsPerformance.log(message)
    return unless RailsPerformance.debug

    if ::Rails.logger
      # puts(message)
      ::Rails.logger.debug(message)
    else
      puts(message)
    end
  end

end

require "rails_performance/engine"

require_relative './rails_performance/gems/custom_ext.rb'
RailsPerformance.send :extend, RailsPerformance::Gems::CustomExtension
