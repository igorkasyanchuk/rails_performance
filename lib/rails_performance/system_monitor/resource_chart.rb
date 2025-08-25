module RailsPerformance
  module SystemMonitor
    ResourceChart = Struct.new(:server, :key, :type, :subtitle, :description, :legend, keyword_init: true) do
      def id
        [key, "report", server.key.parameterize].join("_")
      end

      def data
        all_data = server.report.extract_signal { |e| signal(e) }
        all_data[server.key]
      end

      def signal e
        format(e[key])
      end

      def format measurement
        measurement
      end
    end

    class CPULoad < ResourceChart
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

      def format measurement
        measurement["one_min"].to_f.round(2)
      end

      def measure
        load_averages = Sys::CPU.load_avg
        {
          one_min: load_averages[0],
          five_min: load_averages[1],
          fifteen_min: load_averages[2]
        }
      rescue => e
        ::Rails.logger.error "Error fetching CPU usage: #{e.message}"
        {one_min: 0.0, five_min: 0.0, fifteen_min: 0.0}
      end
    end

    class MemoryUsage < ResourceChart
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

      def format measurement
        measurement.to_f.round(2)
      end

      def measure
        GetProcessMem.new.bytes
      rescue => e
        ::Rails.logger.error "Error fetching memory usage: #{e.message}"
        0
      end
    end

    class DiskUsage < ResourceChart
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

      def signal measurement
        measurement["available"].to_f.round(2)
      end

      def measure
        path = "/"
        stat = Sys::Filesystem.stat(path)
        {
          available: stat.blocks_available * stat.block_size,
          total: stat.blocks * stat.block_size,
          used: (stat.blocks - stat.blocks_available) * stat.block_size
        }
      rescue => e
        ::Rails.logger.error "Error fetching disk space: #{e.message}"
        {available: 0, total: 0, used: 0}
      end
    end
  end
end
