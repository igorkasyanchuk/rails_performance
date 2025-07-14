module RailsPerformance
  module Reports
    class ResourcesReport < BaseReport
      Server = Struct.new(:report, :key) do
        def name
          key.split("///").join(", ")
        end

        def charts
          [
            Chart.new(self, :cpu, "CPU", "CPU usage %, average per 1 minute", "Percentage", "CPU"),
            Chart.new(self, :memory, "Memory", "App memory usage", "Usage", "Usage"),
            Chart.new(self, :disk, "Storage", "Available storage size (local disk size)", "Usage", "Available"),
          ]
        end
      end

      Chart = Struct.new(:server, :key, :subtitle, :description, :type, :legend) do
        def id
          [key, "report", server.key.parameterize].join("_")
        end

        def data
          server.report.send(key)[server.key]
        end
      end

      def servers
        data.keys.map do |key|
          Server.new(self, key)
        end
      end

      def data
        @data ||= db.data
          .collect { |e| e.record_hash }
          .group_by { |e| e[:server] + "///" + e[:context] + "///" + e[:role] }
          # .transform_values { |v| v.sort { |a, b| b[sort] <=> a[sort] } }
          .transform_values { |v| v.map { |e| e.merge({datetimei: e[:datetimei].to_i}) } }
      end

      def cpu
        @cpu ||= data.transform_values do |v|
          prepare_report(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:cpu]["one_min"].to_f.round(2)
          end)
        end
      end

      def memory
        @memory ||= data.transform_values do |v|
          prepare_report(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:memory].to_f.round(2)
          end)
        end
      end

      def disk
        @disk ||= data.transform_values do |v|
          prepare_report(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = e[:disk]["available"].to_f.round(2)
          end)
        end
      end

      private

      def prepare_report(input)
        nullify_data(input, RailsPerformance.system_monitor_duration)
      end
    end
  end
end
