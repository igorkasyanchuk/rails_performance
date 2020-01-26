require "redis"
require "redis-namespace"
require_relative "rails_performance/query_builder.rb"
require_relative "rails_performance/middleware.rb"
require_relative "rails_performance/data_source.rb"
require_relative "rails_performance/record.rb"
require_relative "rails_performance/utils.rb"
require_relative "rails_performance/base_report.rb"
require_relative "rails_performance/requests_report.rb"
require_relative "rails_performance/throughput_report.rb"

require "rails_performance/engine"

module RailsPerformance
  mattr_accessor :redis
  @@redis = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new)

  mattr_accessor :duration
  @@duration = 24.hours

  mattr_accessor :debug
  @@debug = false

  def self.setup
    yield(self)
  end

end

RP = RailsPerformance