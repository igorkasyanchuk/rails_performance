RailsPerformance.setup do |config|
  config.redis    = Redis.new
  config.duration = 72.hours
  config.debug    = false
end