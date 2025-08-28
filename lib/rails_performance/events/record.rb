module RailsPerformance
  module Events
    class Record
      attr_reader :name, :datetimei, :options

      DEFAULT_COLOR = "#FF00FF"
      DEFAULT_LABEL_COLOR = "#FF00FF"
      DEFAULT_LABEL_ORIENTATION = "horizontal"

      class << self
        def create(name:, datetimei: Time.now.to_i, options: {})
          instance = new(name: name, datetimei: datetimei, options: options)
          instance.save
          instance
        end

        def all
          _, values = RailsPerformance::Utils.fetch_from_redis("rails_performance:records:events:*")
          Array(values).map do |value|
            json = JSON.parse(value)
            new(name: json["name"], datetimei: json["datetimei"], options: Hash(json["options"]))
          end
        end
      end

      def initialize(name:, datetimei:, options: {})
        @name = name
        @datetimei = datetimei
        @options = options
      end

      def save
        RailsPerformance::Utils.save_to_redis(rails_performance_key, value)
      end

      def rails_performance_key
        "rails_performance:records:events:#{datetimei}|#{RailsPerformance::EVENTS_SCHEMA}"
      end

      def value
        {
          name: name,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          datetimei: datetimei,
          options: options
        }
      end

      def to_annotation
        {
          x: datetimei * 1000,
          borderColor: options.dig("borderColor") || DEFAULT_COLOR,
          label: {
            borderColor: options.dig("label", "borderColor") || DEFAULT_LABEL_COLOR,
            orientation: options.dig("label", "orientation") || DEFAULT_LABEL_ORIENTATION,
            text: options.dig("label", "text") || name
          }
        }
      end
    end
  end
end
