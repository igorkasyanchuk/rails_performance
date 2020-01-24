module RailsPerformance
  class Record

    attr_reader :controller, :action, :datetime, :datetimei, :path, :metric

    # key = metrics|HomeController|index|20200123T0919|1579789173|/|database = 0
    # value = string
    def initialize(key, value)
      @key   = key
      @value = value

      items = key.split("|")

      @controller = items[1]
      @action     = items[2]
      @datetime   = items[3]
      @datetimei  = items[4].to_i
      @path       = items[5]
      @metric     = items[6]
    end

    def value
      case metric
      when "database", "view_duration", "total_duration"
        @value.to_f
      when "all"
        JSON.parse(@value)
      end
    end

    def controller_action
      "#{controller}##{action}"
    end
  end
end
