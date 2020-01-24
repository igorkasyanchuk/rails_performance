require "redis"
require_relative "rails_performance/middleware.rb"
require_relative "rails_performance/record.rb"
require_relative "rails_performance/base_report.rb"
require_relative "rails_performance/global_report.rb"
require_relative "rails_performance/full_report.rb"

require "rails_performance/engine"

module RailsPerformance
  mattr_accessor :redis
  @@redis = Redis.new

  mattr_accessor :duration
  @@duration = 24.hours

  mattr_accessor :debug
  @@debug = false

  def self.setup
    yield(self)
  end

  # date key in redis store
  def RailsPerformance.cache_key(now = Date.current)
    "date-#{now}"
  end
  # write to current slot
  # time - date -minute
  def RailsPerformance.field_key(now = Time.now)
    now.strftime("%H:%M")
  end

  def RailsPerformance.days
    (RailsPerformance.duration % 24.days).parts[:days] + 1
  end

  def RailsPerformance.median(array)
    sorted = array.sort
    size   = sorted.size
    center = size / 2

    if size == 0
      nil
    elsif size.even?
      (sorted[center - 1] + sorted[center]) / 2.0
    else
      sorted[center]
    end
  end  

  def RailsPerformance.dump
  @data = []

    all = {}
    RailsPerformance.days.times do |e|
      date    = e.days.ago.to_date
      all[date] = RailsPerformance.redis.hgetall(RailsPerformance.cache_key(date))
    end

    stop    = Time.at(60 * (Time.now.to_i / 60))
    current = stop - RailsPerformance.duration

    while current <= stop
      views = all.dig(current.to_date, current.strftime("%H:%M")) || 0

      @data << [current.to_i * 1000, views.to_i]

      current += 1.minute
    end
  
    @data.sort!
  end

  # populate test data
  # run in rails c
  def RailsPerformance.populate_test_data(seed = 20, limit = 10000, days = 7)
    limit.times do
      t = rand(86400*days).seconds.ago # within last 7 days
      RailsPerformance.redis.hincrby(RailsPerformance.cache_key(t.to_date), RailsPerformance.field_key(t), rand(seed))
    end
  end

end