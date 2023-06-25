module RailsPerformance
  module Reports
    class BaseReport
      attr_reader :db, :group, :sort, :title

      def initialize(db, group: nil, sort: nil, title: nil)
        @db     = db
        @group  = group
        @sort   = sort
        @title  = title

        set_defaults
      end

      def collect
        db.group_by(group).inject([]) do |res, (k,v)|
          res << yield(k, v)
          res
        end
      end

      def set_defaults; end

      def self.time_in_app_time_zone(time)
        app_time_zone = ::Rails.application.config.time_zone
        if app_time_zone.present?
          time.in_time_zone(app_time_zone)
        else
          time
        end
      end

      def calculate_data
        now        = Time.current
        stop       = Time.at(60 * ((now.to_i)/ 60))
        offset     = RailsPerformance::Reports::BaseReport::time_in_app_time_zone(now).utc_offset
        current    = stop - RailsPerformance.duration

        @data      = []
        all        = {}

        # read current values
        db.group_by(group).each do |(k, v)|
          yield(all, k, v)
        end

        # add blank columns
        while current <= stop
          key   = (current).strftime(RailsPerformance::FORMAT)
          views = all[key].presence || 0
          @data << [(current.to_i + offset) * 1000, views.round(2)]
          current += 1.minute
        end

        # sort by time
        @data.sort!
      end
    end
  end
end
