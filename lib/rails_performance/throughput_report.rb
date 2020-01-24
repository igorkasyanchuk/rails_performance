module RailsPerformance
  class ThroughputReport < BaseReport

    def initialize(ds)
      super(ds, group: :datetime)
    end

    def data
      all     = {}
      stop    = Time.at(60 * (Time.now.to_i / 60))
      current = stop - RailsPerformance.duration
      @data   = []

      # read current values
      db.group_by(group).values.each do |(k, v)|
        all[k] = v.count
      end

      # add blank columns
      while current <= stop
        views = all[current.strftime(MetricsListener::FORMAT)] || 0
        @data << [current.to_i * 1000, views.to_i]
        current += 1.minute
      end

      # sort by time
      @data.sort!
    end

  end
end