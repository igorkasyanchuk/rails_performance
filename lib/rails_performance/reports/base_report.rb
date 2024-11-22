module RailsPerformance
  module Reports
    class BaseReport
      attr_reader :db, :group, :sort, :title

      def initialize(db, group: nil, sort: nil, title: nil)
        @db = db
        @group = group
        @sort = sort
        @title = title

        set_defaults
      end

      def set_defaults
      end

      def collect
        db.group_by(group).each_with_object([]) do |(k, v), res|
          res << yield(k, v)
        end
      end

      def self.time_in_app_time_zone(time)
        app_time_zone = ::Rails.application.config.time_zone
        if app_time_zone.present?
          time.in_time_zone(app_time_zone)
        else
          time
        end
      end

      # TODO: simplify this method, and combine with nullify_data
      def calculate_data
        now = RailsPerformance::Utils.time
        now = now.change(sec: 0, usec: 0)
        stop = now # Time.at(60 * (now.to_i / 60), in:)
        offset = 0 # RailsPerformance::Reports::BaseReport.time_in_app_time_zone(now).utc_offset
        current = stop - RailsPerformance.duration

        @data = []
        all = {}

        db.group_by(group).each do |(k, v)|
          yield(all, k, v)
        end

        # add blank columns
        while current <= stop
          key = current.strftime(RailsPerformance::FORMAT)
          views = all[key].presence || 0
          @data << [(current.to_i + offset) * 1000, views.round(2)]
          current += 1.minute
        end

        # sort by time
        @data.sort!
      end

      # Generate series for our time range -> (now - duration)..now
      # {
      #   1732125540000 => 0,
      #   1732125550000 => 0,
      #   ....
      # }
      def nil_data(duration = RailsPerformance.duration)
        @nil_data ||= begin
          result = {}
          now = RailsPerformance::Utils.time
          now = now.change(sec: 0, usec: 0)
          stop = now # Time.at(60 * (now.to_i / 60))
          offset = 0 # RailsPerformance::Reports::BaseReport.time_in_app_time_zone(now).utc_offset
          current = stop - duration

          while current <= stop
            current.strftime(RailsPerformance::FORMAT)
            result[(current.to_i + offset) * 1000] = nil
            current += 1.minute
          end

          result
        end
      end

      # {
      #   1732125540000 => 1,
      #   1732125550000 => 0,
      # }
      def nullify_data(input, duration = RailsPerformance.duration)
        nil_data(duration).merge(input).sort
      end
    end
  end
end
