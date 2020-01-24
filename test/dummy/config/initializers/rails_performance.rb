RailsPerformance.setup do |config|
  config.redis    = Redis.new
  config.duration = 1.hours
  config.debug    = false
end