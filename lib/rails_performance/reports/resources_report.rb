module RailsPerformance
  module Reports
    class ResourcesReport < BaseReport
      Server = Struct.new(:report, :key) do
        def name
          key.split("///").join(", ")
        end

        def charts
          RailsPerformance.system_monitors.map do |class_name|
            SystemMonitor.const_get(class_name).new(self)
          end
        end
      end

      def servers
        data.keys.map do |key|
          Server.new(self, key)
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
