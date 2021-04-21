module RailsPerformance
  module Models
    class RakeRecord < BaseRecord
      attr_accessor :task, :duration, :datetime, :datetimei, :status

      # rake|task|["task3"]|datetime|20210416T1254|datetimei|1618602843|status|error|END|1.0.0
      # {"duration":0.00012442}
      def RakeRecord.from_db(key, value)
        items = key.split("|")

        RakeRecord.new(
          task: JSON.parse(items[2]),
          datetime: items[4],
          datetimei: items[6],
          status: items[8],
          json: value
        )
      end

      def initialize(task:, duration: nil, datetime:, datetimei:, status:, json: '{}')
        @task         = Array.wrap(task)
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @status       = status
        @duration     = duration
        @json         = json

        @duration ||= value['duration']
      end

      def record_hash
        {
          task: task,
          datetime: Time.at(datetimei),
          datetimei: datetimei,
          duration: duration,
          status: status,
        }
      end

      def save
        key   = "rake|task|#{task.to_json}|datetime|#{datetime}|datetimei|#{datetimei}|status|#{status}|END|#{RailsPerformance::SCHEMA}"
        value = { duration: duration }
        Utils.save_to_redis(key, value)
      end

    end
  end
end