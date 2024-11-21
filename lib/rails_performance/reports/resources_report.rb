module RailsPerformance
  module Reports
    class ResourcesReport < BaseReport
      def self.x
        @datasource = RailsPerformance::DataSource.new(type: :resources)
        db = @datasource.db
        @data = RailsPerformance::Reports::ResourcesReport.new(db)
        # RailsPerformance::Reports::ResourcesReport.x
      end

      def data
        @data ||= db.data
          .collect { |e| e.record_hash }
          .group_by { |e| e[:server] + "///" + e[:context] + "///" + e[:role] }
          .transform_values { |v| v.sort { |a, b| b[sort] <=> a[sort] } }
          .transform_values { |v| v.map { |e| e.merge({datetimei: e[:datetimei].to_i}) } }
      end

      def cpu
        @cpu ||= data.transform_values do |v|
          nullify_data(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:cpu]["one_min"].to_f.round(2)
          end)
        end
      end

      def memory
        @memory ||= data.transform_values do |v|
          nullify_data(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:memory].to_f.round(2)
          end)
        end
      end

      def disk
        @disk ||= data.transform_values do |v|
          nullify_data(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:disk]["available"].to_f.round(2)
          end)
        end
      end
    end
  end
end
