module RailsPerformance

  class Utils
    # date key in redis store
    def Utils.cache_key(now = Date.today)
      "date-#{now}"
    end

    # write to current slot
    # time - date -minute
    def Utils.field_key(now = Time.now)
      now.strftime("%H:%M")
    end

    def Utils.log_trace_in_redis(request_id, value)
      key = "trace|#{request_id}"
      Utils.save_to_redis(key, value, RailsPerformance::Reports::RecentRequestsReport::TIME_WINDOW.to_i)
    end

    def Utils.fetch_from_redis(query)
      #puts "\n\n   [REDIS QUERY]   -->   #{query}\n\n"

      keys   = RP.redis.keys(query)
      return [] if keys.blank?
      values = RP.redis.mget(keys)

      [keys, values]
    end

    def Utils.days
      (RP.duration / 1.day) + 1
    end

    def Utils.median(array)
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

    def Utils.save_to_redis(key, value, expire = RP.duration.to_i)
      # TODO think here if add return
      #return if value.empty?

      RailsPerformance.log "  [SAVE]    key  --->  #{key}\n"
      RailsPerformance.log "          value  --->  #{value.to_json}\n\n"
      RP.redis.set(key, value.to_json, ex: expire.to_i)
    end

  end
end
