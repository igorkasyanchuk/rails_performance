module RailsPerformance
  module Models
    class ResourceRecord < BaseRecord
      attr_accessor :server, :context, :role, :datetime, :datetimei, :json

      def initialize(server:, context:, role:, datetime: Time.current, json:)
        @server = server
        @context = context
        @role = role
        @datetime = datetime
        @datetimei = datetime.to_i
        @json = json
      end

      def self.from_db(key, value)
        items = key.split("|")

        ResourceRecord.new(
          server: items[2],
          context: items[4],
          role: items[6],
          datetime: items[8],
          json: value
        )
      end

      def record_hash

        puts value

        {
          server: server,
          role: role,
          context: context,
          datetime: datetime,
          datetimei: datetimei,
          cpu: value["cpu"],
          memory: value["memory"],
          disk: value["disk"]
        }
      end

      def combined_key
        "server|#{server}|context|#{context}|role|#{role}"
      end

      def save
        key = "resource|server|#{server}|context|#{context}|role|#{role}|datetime|#{datetime}|datetimei|#{datetimei}|END|#{RailsPerformance::SCHEMA}"
        Utils.save_to_redis(key, json)
      end
    end
  end
end
