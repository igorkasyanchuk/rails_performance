module RailsPerformance
  class GlobalReport < BaseReport
    def data(group)
      collect(group) do |k, v|
        {
          group: k,
          average: v.sum.to_f / v.size,
          count: v.size,
          slowest: v.max
        }
      end.sort{|a, b| b[:count] <=> a[:count]}
    end
  end
end