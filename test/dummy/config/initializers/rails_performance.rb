RailsPerformance.setup do |config|
  config.redis    = Redis.new
  config.duration = 1.hour
  config.debug    = false
end