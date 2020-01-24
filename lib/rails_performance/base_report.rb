module RailsPerformance
  class BaseReport
    attr_reader :db, :group

    def initialize(db, group: nil)
      @db     = db
      @group  = group
    end

    def collect
      db.group_by(group).values.inject([]) do |res, (k,v)|
        res << yield(k, v)
        res
      end
    end
  end
end