module RailsPerformance
  module Reports
    class BreakdownReport < BaseReport
      def set_defaults
        @sort ||= :datetime
      end

      def data
        db.data.collect do |record|
          {
            controller: record.controller,
            action: record.action,
            format: record.format,
            status: record.status,
            method: record.method,
            path: record.path,
            datetime: Time.parse(record.datetime),
            duration: record.value['duration'],
            db_runtime: record.value['db_runtime'],
            view_runtime: record.value['view_runtime'],
          }
        end.sort{|a, b| b[sort] <=> a[sort]}
      end
    end


  end
end