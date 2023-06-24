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
    end
  end
end
