module RailsPerformance
  module Models
    class SidekiqRecord < BaseRecord
      attr_accessor :queue, :worker, :jid, :datetimei, :enqueued_ati, :datetime, :start_timei, :status, :duration, :message

      # key = job-performance
      # |queue|default
      # |worker|SimpleWorker
      # |jid|7d48fbf20976c224510dbc60
      # |datetime|20200124T0523
      # |datetimei|1583146613
      # |enqueued_ati|1583146613
      # |start_timei|1583146614
      # |status|success|END|1.0.0
      # value = JSON
      def SidekiqRecord.from_db(key, value)
        items = key.split("|")

        SidekiqRecord.new(
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

      def initialize(queue:, worker:, jid:, datetime:, datetimei:, enqueued_ati:, start_timei:, status: nil, duration: nil, json: "{}")
        @queue        = queue
        @worker       = worker
        @jid          = jid
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @enqueued_ati = enqueued_ati
        @start_timei  = start_timei
        @status       = status
        @duration     = duration
        @json         = json
      end

      def record_hash
        {
          worker: self.worker,
          queue: self.queue,
          jid: self.jid,
          status: self.status,
          datetimei: datetimei,
          datetime: Time.at(self.start_timei.to_i),
          duration: self.value['duration'],
          message: value['message']
        }
      end

      def save
        key   = "sidekiq|queue|#{queue}|worker|#{worker}|jid|#{jid}|datetime|#{datetime}|datetimei|#{datetimei}|enqueued_ati|#{enqueued_ati}|start_timei|#{start_timei}|status|#{status}|END|#{RailsPerformance::SCHEMA}"
        value = { message: message, duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end