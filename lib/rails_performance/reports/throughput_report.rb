module RailsPerformance
  module Reports
    class ThroughputReport < BaseReport

      def set_defaults
        @group ||= :datetime
      end

      def data
        all     = {}
        stop    = Time.at(60 * (Time.now.to_i / 60))
        current = stop - RailsPerformance.duration
        @data   = []
        offset  = Time.now.utc_offset

        # puts "current: #{current}"
        # puts "stop: #{stop}"

        # read current values
        db.group_by(group).each do |(k, v)|
          all[k] = v.count
        end

        # add blank columns
        while current <= stop
          views = all[current.strftime(RailsPerformance::FORMAT)] || 0
          time = RailsPerformance::Reports::ResponseTimeReport::time_in_app_time_zone(current)
          @data << [(time.to_i + offset) * 1000, views.round(2)]
          current += 1.minute
        end

        # sort by time
        @data.sort!
      end

    end
  end
end
