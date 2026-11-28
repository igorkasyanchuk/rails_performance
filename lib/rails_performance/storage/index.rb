module RailsPerformance
  module Storage
    # groups keys into "type:YYYYMMDD" buckets, so stores without pattern search can narrow down the lookup
    module Index
      extend self

      DATE_REGEXP = /datetime\|(\d{8})/
      EVENTS_PREFIX = "rails_performance:records:events:"

      # returns nil for keys which are read only by exact key (e.g. traces)
      def bucket_for(key)
        type = type_for(key)
        date = date_for(key)
        "#{type}:#{date}" if type && date
      end

      def buckets_for(pattern)
        type = type_for(pattern)
        return [] unless type

        date = date_for(pattern)
        dates = date ? [date] : recent_dates
        dates.map { |e| "#{type}:#{e}" }
      end

      # same semantics as Redis KEYS pattern
      def match?(pattern, key)
        File.fnmatch?(pattern, key, File::FNM_DOTMATCH)
      end

      private

      def type_for(key)
        return "events" if key.start_with?(EVENTS_PREFIX)

        type = key.split("|", 2).first
        type unless type.match?(/[*?\[\\]/)
      end

      def date_for(key)
        if key.start_with?(EVENTS_PREFIX)
          datetimei = key.delete_prefix(EVENTS_PREFIX)[/\A\d+(?=\|)/]
          RailsPerformance::Utils.from_datetimei(datetimei.to_i).strftime("%Y%m%d") if datetimei
        else
          key[DATE_REGEXP, 1]
        end
      end

      # records can be stored with a date in the future, see Utils.kind_of_now
      def recent_dates
        today = RailsPerformance::Utils.time.to_date
        days = RailsPerformance::Utils.days([RailsPerformance.duration, RailsPerformance.system_monitor_duration].max)
        (-1..days).map { |e| (today - e).strftime("%Y%m%d") }
      end
    end
  end
end
