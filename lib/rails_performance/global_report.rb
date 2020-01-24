module RailsPerformance
  class GlobalReport < BaseReport
    def data
      collect do |k, v|
        {
          group: k,
          average: v.sum{|e| e["duration"]}.to_f / v.size,
          count: v.size,
          slowest: v.max{|e| e["duration"]}.try(:[], "duration")
        }
      end.sort{|a, b| b[:count] <=> a[:count]}
    end
  end
end