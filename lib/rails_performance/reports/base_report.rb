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
    end
  end
end