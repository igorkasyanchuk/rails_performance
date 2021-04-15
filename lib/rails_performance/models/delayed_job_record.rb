module RailsPerformance
  module Models
    class DelayedJobRecord < BaseRecord
      attr_accessor :jid, :duration, :datetime, :datetimei, :source_type, :class_name, :method_name, :status

      # delayed_job
      #|jid|22
      #|datetime|20210415T0616
      #|datetimei|1618492591
      #|source_type|instance_method
      #|class_name|User
      #|method_name|say_hello_without_delay
      #|status|success|END
      def DelayedJobRecord.from_db(key, value)
        items = key.split("|")

        DelayedJobRecord.new(
          jid: items[2],
          datetime: items[],
          datetimei: items[],
          duration: items[],
          status: items[],
          source_type: items[],
          class_name: items[],
          method_name: items[],
        )
      end

      def initialize(jid:, duration:, datetime:, datetimei:, source_type:, class_name:, method_name:, status:)
        @jid          = jid
        @duration     = duration
        @datetime     = datetime
        @datetimei    = datetimei
        @source_type  = source_type
        @class_name   = class_name
        @method_name  = method_name
        @status       = status
        @json         = {}
      end

      def to_h
        {
          jid: jid,
          datetime: datetime,
          datetimei: datetimei,
          duration: duration,
          status: status,
          source_type: source_type,
          class_name: class_name,
          method_name: method_name,
        }
      end

      def record_hash
        to_h
      end

      def save
        key   = "delayed_job|jid|#{jid}|datetime|#{datetime}|datetimei|#{datetimei}|source_type|#{source_type}|class_name|#{class_name}|method_name|#{method_name}|status|#{status}|END"
        value = { duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end