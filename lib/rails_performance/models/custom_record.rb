module RailsPerformance
  module Models
    class CustomRecord < BaseRecord
      attr_accessor :tag_name, :namespace_name, :duration, :datetime, :datetimei, :status, :json

      def CustomRecord.from_db(key, value)
        items = key.split("|")

        CustomRecord.new(
          tag_name: items[2],
          namespace_name: items[4],
          datetime: items[6],
          datetimei: items[8],
          status: items[10],
          json: value
        )
      end

      def initialize(tag_name:, namespace_name: nil, duration: nil, datetime:, datetimei:, status:, json: '{}')
        @tag_name       = tag_name
        @namespace_name = namespace_name
        @duration       = duration
        @datetime       = datetime
        @datetimei      = datetimei.to_i
        @status         = status
        @json           = json
      end

      def record_hash
        {
          tag_name: self.tag_name,
          namespace_name: self.namespace_name,
          status: self.status,
          datetimei: datetimei,
          datetime: Time.at(self.datetimei.to_i),
          duration: self.value['duration'],
        }
      end

      def save
        key   = "custom|tag_name|#{tag_name}|namespace_name|#{namespace_name}|datetime|#{datetime}|datetimei|#{datetimei}|status|#{status}|END|#{RailsPerformance::SCHEMA}"
        value = { duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end