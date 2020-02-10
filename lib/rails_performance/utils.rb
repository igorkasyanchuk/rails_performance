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

    def Utils.log_request_in_redis(e)
      value = e.slice(:view_runtime, :db_runtime, :duration)
      key   = "performance|controller|#{e[:controller]}|action|#{e[:action]}|format|#{e[:format]}|status|#{e[:status]}|datetime|#{e[:datetime]}|datetimei|#{e[:datetimei]}|method|#{e[:method]}|path|#{e[:path]}|request_id|#{e[:request_id]}|END"

      # puts "  [SAVE]    key  --->  #{key}\n"
      # puts "          value  --->  #{value.to_json}\n\n"

      RP.redis.set(key, value.to_json)
      RP.redis.expire(key, RP.duration.to_i)

      true
    end

    def Utils.log_trace_in_redis(request_id, value)
      key = "trace|#{request_id}"

      # puts "  [SAVE]    key  --->  #{key}\n"
      # puts "          value  --->  #{value.to_json}\n\n"
      # pp value

      RP.redis.set(key, value.to_json)
      RP.redis.expire(key, RailsPerformance::Reports::RecentRequestsReport::TIME_WINDOW.to_i)
    end

    def Utils.fetch_from_redis(query)
      #puts "\n\n   [REDIS QUERY]   -->   #{query}\n\n"

      keys   = RP.redis.keys(query)
      return [] if keys.blank?
      values = RP.redis.mget(keys)

      [keys, values]
    end

    def Utils.days
      (RP.duration % 24.days).parts[:days] + 1
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

  end
end