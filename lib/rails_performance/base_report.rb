module RailsPerformance
  class BaseReport
    attr_reader :datasource, :group

    def initialize(datasource, group: nil)
      @datasource = datasource
      @group = group
    end

    def collect
      datasource.collection.group_by(group).values.inject([]) do |res, (k,v)|
        res << yield(k, v)
        res
      end
    end
  end
end