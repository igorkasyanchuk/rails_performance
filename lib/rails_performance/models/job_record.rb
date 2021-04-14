module RailsPerformance
  module Models
    class JobRecord < BaseRecord
      attr_accessor :queue, :worker, :jid, :created_ati, :enqueued_ati, :datetime, :start_timei, :status, :duration, :message

      # key = job-performance
      # |queue|default
      # |worker|SimpleWorker
      # |jid|7d48fbf20976c224510dbc60
      # |datetime|20200124T0523
      # |created_ati|1583146613
      # |enqueued_ati|1583146613
      # |start_timei|1583146614
      # |status|success|END
      # value = JSON
      def JobRecord.from_db(key, value)
        items = key.split("|")

        JobRecord.new(
          queue: items[2],
          worker: items[4],
          jid: items[6],
          datetime: items[8],
          created_ati: items[10],
          enqueued_ati: items[12],
          start_timei: items[14],
          status: items[16],
          json: value
        )
      end

      def initialize(queue:, worker:, jid:, datetime:, created_ati:, enqueued_ati:, start_timei:, status: nil, duration: nil, json: "{}")
        @queue        = queue
        @worker       = worker
        @jid          = jid
        @datetime     = datetime
        @created_ati  = created_ati
        @enqueued_ati = enqueued_ati
        @start_timei  = start_timei
        @status       = status
        @duration     = duration
        @json         = json
      end

      def to_h
        {
          queue: queue,
          worker: worker,
          jid: jid,
          datetime: datetime,
          created_ati: created_ati,
          enqueued_ati: enqueued_ati,
          start_timei: start_timei,
          duration: duration,
          status: status,
          message: value['message']
        }
      end

      def save
        key   = "jobs|queue|#{queue}|worker|#{worker}|jid|#{jid}|datetime|#{datetime}|created_ati|#{created_ati}|enqueued_ati|#{enqueued_ati}|start_timei|#{start_timei}|status|#{status}|END"
        value = { message: message, duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end