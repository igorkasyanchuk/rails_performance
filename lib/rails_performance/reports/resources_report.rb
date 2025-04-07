module RailsPerformance
  module Reports
    class ResourcesReport < BaseReport
      Server = Struct.new(:report, :key) do
        def name
          key.split("///").join(", ")
        end

        def charts
          RailsPerformance.system_monitor_charts.map do |class_name|
            ResourcesReport.const_get(class_name).new(self)
          end
        end
      end

      def servers
        data.keys.map do |key|
          Server.new(self, key)
        end
      end

      Chart = Struct.new(:server, :key, :type, :subtitle, :description, :legend, keyword_init: true) do
        def id
          [key, "report", server.key.parameterize].join("_")
        end

        def data
          all_data = server.report.extract_signal { |e| signal(e) }
          all_data[server.key]
        end
      end

      class CPUChart < Chart
        def initialize server
          super(
            server:,
            key: :cpu,
            type: "Percentage",
            subtitle: "CPU",
            description: "CPU load average (1 min), average per 1 minute",
            legend: "CPU",
          )
        end

        def signal e
          e[:cpu]["one_min"].to_f.round(2)
        end
      end

      class MemoryChart < Chart
        def initialize server
          super(
            server:,
            key: :memory,
            type: "Usage",
            subtitle: "Memory",
            description: "App memory usage",
            legend: "Usage",
          )
        end

        def signal e
          e[:memory].to_f.round(2)
        end
      end

      class DiskChart < Chart
        def initialize server
          super(
            server:,
            key: :disk,
            type: "Usage",
            subtitle: "Storage",
            description: "Available storage size (local disk size)",
            legend: "Usage",
          )
        end

        def signal e
          e[:disk]["available"].to_f.round(2)
        end
      end

      def extract_signal &block
        data.transform_values do |v|
          prepare_report(v.each_with_object({}) do |e, res|
            res[e[:datetimei] * 1000] = block.call(e)
          end)
        end
      end

      private

      def data
        @data ||= db.data
          .collect { |e| e.record_hash }
          .group_by { |e| e[:server] + "///" + e[:context] + "///" + e[:role] }
          # .transform_values { |v| v.sort { |a, b| b[sort] <=> a[sort] } }
          .transform_values { |v| v.map { |e| e.merge({datetimei: e[:datetimei].to_i}) } }
      end

      def prepare_report(input)
        nullify_data(input, RailsPerformance.system_monitor_duration)
      end
    end
  end
end
