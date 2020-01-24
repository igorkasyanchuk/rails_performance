module RailsPerformance
  class BaseReport
    def collect(group)
      keys   = RailsPerformance.redis.keys("*#{Date.current.strftime("%Y%m%d")}*|*total_duration")
      values = RailsPerformance.redis.mget(keys)

      @collection = RailsPerformance::Collection.new

      keys.each_with_index do |key, index|
        @collection.data << RailsPerformance::Record.new(key, values[index])
      end

      @collection.group_by(group).values.inject([]) do |res, (k,v)|
        res << yield(k, v)
        res
      end
    end
  end
end