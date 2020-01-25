module RailsPerformance
  class BaseReport
    attr_reader :db, :group, :sort

    def initialize(db, group: nil, sort: nil)
      @db     = db
      @group  = group
      @sort   = sort

      set_defaults
    end

    def collect
      db.group_by(group).values.inject([]) do |res, (k,v)|
        res << yield(k, v)
        res
      end
    end

    def set_defaults
    end
  end
end