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

    def Utils.log_in_redis(e)
      value = e.slice(:view_runtime, :db_runtime, :duration)
      key   = "performance|controller|#{e[:controller]}|action|#{e[:action]}|format|#{e[:format]}|status|#{e[:status]}|datetime|#{e[:datetime]}|datetimei|#{e[:datetimei]}|method|#{e[:method]}|path|#{e[:path]}|END"

      #puts "  [SAVE]    key  --->  #{key}\n"
      #puts "          value  --->  #{value.to_json}\n\n"

      RP.redis.set(key, value.to_json)
      RP.redis.expire(key, RP.duration.to_i)
      true
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

    # populate test data
    # run in rails c
    def Utils.populate_test_data(seed = 20, limit = 10000, days = 7)
      limit.times do
        t = rand(86400*days).seconds.ago # within last 7 days
        RP.redis.hincrby(cache_key(t.to_date), field_key(t), rand(seed))
      end
    end
  end
end