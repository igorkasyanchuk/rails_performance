module RailsPerformance
  module Extensions
    class ResourceMonitor
      attr_reader :context, :role

      def initialize(context, role)
        @context = context
        @role = role
        @mutex = Mutex.new
        @thread = nil

        return unless RailsPerformance._resource_monitor_enabled

        start_monitoring
      end

      def start_monitoring
        @mutex.synchronize do
          return if @thread

          @thread = Thread.new do
            loop do
              run
            rescue => e
              ::Rails.logger.error "Monitor error: #{e.message}"
            ensure
              sleep 60
            end
          end
        end
      end

      def stop_monitoring
        @mutex.synchronize do
          return unless @thread

          @thread.kill
          @thread = nil
        end
      end

      def run
        cpu = fetch_process_cpu_usage
        memory = fetch_process_memory_usage
        disk = fetch_disk_usage

        store_data({cpu: cpu, memory: memory, disk: disk})
      end

      def fetch_process_cpu_usage
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

      def fetch_process_memory_usage
        GetProcessMem.new.bytes
      rescue => e
        ::Rails.logger.error "Error fetching memory usage: #{e.message}"
        0
      end

      def fetch_disk_usage(path = "/")
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

      def store_data(data)
        ::Rails.logger.info("Server: #{server_id}, Context: #{context}, Role: #{role}, data: #{data}")

        now = RailsPerformance::Utils.time
        now = now.change(sec: 0, usec: 0)
        RailsPerformance::Models::ResourceRecord.new(
          server: server_id,
          context: context,
          role: role,
          datetime: now.strftime(RailsPerformance::FORMAT),
          datetimei: now.to_i,
          json: data
        ).save
      end

      def server_id
        @server_id ||= ENV["RAILS_PERFORMANCE_SERVER_ID"] || `hostname`.strip
      end
    end
  end
end
