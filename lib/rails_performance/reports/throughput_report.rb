module RailsPerformance
  module Reports
    class ThroughputReport < BaseReport

      def set_defaults
        @group ||= :datetime
      end

      # RailsPerformance::Reports::ThroughputReport.new(db).data
      # Time.at(RailsPerformance::Reports::ThroughputReport.new(db).data.last[0] / 1000)

      def data
        all     = {}
        stop    = RailsPerformance::Reports::BaseReport::time_in_app_time_zone(Time.at(60 * (Time.now.to_i / 60)))
        offset  = RailsPerformance::Reports::BaseReport::time_in_app_time_zone(Time.now).utc_offset
        current = stop - RailsPerformance.duration
        @data   = []

        # puts "current: #{current}"
        # puts "stop: #{stop}"

        # read current values
        db.group_by(group).each do |(k, v)|
          all[k] = v.count
        end

        # add blank columns
        while current <= stop
          views = all[current.strftime(RailsPerformance::FORMAT)] || 0
          @data << [(current.to_i + offset) * 1000, views.round(2)]
          current += 1.minute
        end

        # sort by time
        @data.sort!
      end

    end
  end
end
