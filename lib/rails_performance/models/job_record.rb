module RailsPerformance
  module Models
    class JobRecord < BaseRecord
      attr_reader :queue, :worker, :jid, :created_ati, :enqueued_ati, :datetime, :start_timei, :status

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
      def initialize(key, value)
        @json = value

        items = key.split("|")

        @queue        = items[2]
        @worker       = items[4]
        @jid          = items[6]
        @datetime     = items[8]
        @created_ati  = items[10]
        @enqueued_ati = items[12]
        @start_timei  = items[14]
        @status       = items[16]
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

    end
  end
end