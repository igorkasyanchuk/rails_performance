module RailsPerformance
  module Models
    class DelayedJobRecord < BaseRecord
      attr_accessor :jid, :duration, :datetime, :datetimei, :source_type, :class_name, :method_name, :status, :json

      # delayed_job
      #|jid|22
      #|datetime|20210415T0616
      #|datetimei|1618492591
      #|source_type|instance_method
      #|class_name|User
      #|method_name|say_hello_without_delay
      #|status|success|END|1.0.0
      def DelayedJobRecord.from_db(key, value)
        items = key.split("|")

        DelayedJobRecord.new(
          jid: items[2],
          datetime: items[4],
          datetimei: items[6],
          source_type: items[8],
          class_name: items[10],
          method_name: items[12],
          status: items[14],
          json: value
        )
      end

      def initialize(jid:, duration: nil, datetime:, datetimei:, source_type:, class_name:, method_name:, status:, json: '{}')
        @jid          = jid
        @duration     = duration
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @source_type  = source_type
        @class_name   = class_name
        @method_name  = method_name
        @status       = status
        @json         = json
      end

      def record_hash
        {
          jid: jid,
          datetime: Time.at(datetimei),
          datetimei: datetimei,
          duration: value['duration'],
          status: status,
          source_type: source_type,
          class_name: class_name,
          method_name: method_name,
        }
      end

      def save
        key   = "delayed_job|jid|#{jid}|datetime|#{datetime}|datetimei|#{datetimei}|source_type|#{source_type}|class_name|#{class_name}|method_name|#{method_name}|status|#{status}|END|#{RailsPerformance::SCHEMA}"
        value = { duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end