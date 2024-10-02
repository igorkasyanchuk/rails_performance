module RailsPerformance
  module Models
    class ActiveJobRecord < BaseRecord
      SCHEMA = 1.0

      attr_accessor :queue, :worker, :jid, :datetimei, :enqueued_ati, :datetime, :start_timei, :duration, :status, :message

      # deserialize from redis
      def ActiveJobRecord.from_db(key, value)
        items = key.split("|")

        ActiveJobRecord.new(
          queue: items[2],
          worker: items[4],
          jid: items[6],
          datetime: items[8],
          datetimei: items[10],
          enqueued_ati: items[12],
          start_timei: items[14],
          status: items[16],
          json: value
        )
      end

      def initialize(queue:, worker:, jid:, datetime:, datetimei:, enqueued_ati:, start_timei:, duration: nil, status: nil, message: nil, json: "{}")
        @queue        = queue
        @worker       = worker
        @jid          = jid
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @start_timei  = start_timei
        @enqueued_ati = enqueued_ati
        @duration     = duration
        @status       = status
        @message      = message
        @json         = json
      end

      # For UI
      def record_hash
        {
          worker: self.worker,
          queue: self.queue,
          jid: self.jid,
          datetimei: datetimei,
          datetime: Time.at(self.datetimei),
          start_timei: self.start_timei,
          duration: self.value['duration'],
          message: self.value['message'],
          status: self.status
        }
      end

      # serialize to redis
      def save
        key   = "active_job|queue|#{queue}|worker|#{worker}|jid|#{jid}|datetime|#{datetime}|datetimei|#{datetimei}|enqueued_ati|#{enqueued_ati}|start_timei|#{start_timei}|status|#{status}|END|#{SCHEMA}"
        value = { duration:, message: }
        Utils.save_to_redis(key, value)
      end

    end
  end
end
