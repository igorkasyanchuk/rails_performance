module RailsPerformance
  module Models
    class ActiveJobRecord < BaseRecord
      SCHEMA = 1.0

      attr_accessor :queue, :worker, :jid, :datetimei, :enqueued_ati, :datetime, :start_timei, :db_runtime, :aborted

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
          json: value
        )
      end

      def initialize(queue:, worker:, jid:, datetime:, datetimei:, enqueued_ati:, start_timei:, db_runtime: nil, aborted: nil, json: "{}")
        @queue        = queue
        @worker       = worker
        @jid          = jid
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @start_timei  = start_timei
        @enqueued_ati = enqueued_ati
        @db_runtime   = db_runtime
        @aborted      = ActiveModel::Type::Boolean.new.cast(aborted)
        @json         = json
      end

      def record_hash
        {
          worker: self.worker,
          queue: self.queue,
          jid: self.jid,
          datetimei: datetimei,
          datetime: Time.at(self.datetimei),
          start_timei: self.start_timei,
          db_runtime: self.value['db_runtime'],
          aborted: ActiveModel::Type::Boolean.new.cast(self.value['aborted'])
        }
      end

      def save
        key   = "active_job|queue|#{queue}|worker|#{worker}|jid|#{jid}|datetime|#{datetime}|datetimei|#{datetimei}|enqueued_ati|#{enqueued_ati}|start_timei|#{start_timei}|END|#{SCHEMA}"
        value = { db_runtime:, aborted: }
        binding.pry
        Utils.save_to_redis(key, value)
      end

    end
  end
end
