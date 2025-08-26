module RailsPerformance
  module Events
    class Record
      attr_reader :name, :datetimei

      class << self
        def create(name:, datetimei: Time.now.to_i)
          instance = new(name: name, datetimei: datetimei)
          instance.save
          instance
        end

        def all
          _, values = RailsPerformance::Utils.fetch_from_redis("rails_performance:records:events:*")
          values.map do |value|
            json = JSON.parse(value)
            new(name: json["name"], datetimei: json["datetimei"])
          end
        end
      end

      def initialize(name:, datetimei:)
        @name = name
        @datetimei = datetimei
      end

      def save
        RailsPerformance::Utils.save_to_redis(rails_performance_key, value)
      end

      def rails_performance_key
        "rails_performance:records:events:#{datetimei}|#{RailsPerformance::SCHEMA}"
      end

      def value
        {
          name: name,
          datetime: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          datetimei: datetimei
        }
      end

      def to_annotation
        {
          x: datetimei * 1000,
          borderColor: "#00E396",
          label: {
            borderColor: "#00E396",
            orientation: "horizontal",
            text: name
          }
        }
      end
    end
  end
end
