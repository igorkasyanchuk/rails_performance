module RailsPerformance
  module Interface
    def create_event(name:, datetime: RailsPerformance::Utils.time, options: {})
      RailsPerformance::Events::Record.create(name: name, datetimei: datetime.to_i, options: options)
    end
  end
end
