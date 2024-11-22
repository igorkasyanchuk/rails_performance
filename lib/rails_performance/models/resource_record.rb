module RailsPerformance
  module Models
    class ResourceRecord < BaseRecord
      attr_accessor :server, :context, :role, :datetime, :datetimei, :json

      def initialize(server:, context:, role:, datetime:, datetimei:, json:)
        @server = server
        @context = context
        @role = role
        @datetime = datetime
        @datetimei = datetimei
        @json = json
      end

      def self.from_db(key, value)
        items = key.split("|")

        ResourceRecord.new(
          server: items[2],
          context: items[4],
          role: items[6],
          datetime: items[8],
          datetimei: items[10],
          json: value
        )
      end

      def record_hash
        {
          server: server,
          role: role,
          context: context,
          datetime: datetime,
          datetimei: RailsPerformance::Utils.from_datetimei(datetimei.to_i),
          cpu: value["cpu"],
          memory: value["memory"],
          disk: value["disk"]
        }
      end

      def save
        key = "resource|server|#{server}|context|#{context}|role|#{role}|datetime|#{datetime}|datetimei|#{datetimei}|END|#{RailsPerformance::SCHEMA}"
        # with longer expiration time
        Utils.save_to_redis(key, json, RailsPerformance.system_monitor_duration.to_i)
      end
    end
  end
end
