module RailsPerformance
  class ThroughputReport < BaseReport

    def data
      @data = []

      all = {}
      RP::Utils.days.times do |e|
        date    = e.days.ago.to_date
        all[date] = RP.redis.hgetall(RP::Utils.cache_key(date))
      end

      stop    = Time.at(60 * (Time.now.to_i / 60))
      current = stop - RP.duration

      while current <= stop
        views = all.dig(current.to_date, current.strftime("%H:%M")) || 0

        @data << [current.to_i * 1000, views.to_i]

        current += 1.minute
      end
    
      @data.sort!
    end

  end
end