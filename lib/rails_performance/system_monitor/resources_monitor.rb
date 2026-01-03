module RailsPerformance
  module SystemMonitor
    class ResourcesMonitor
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

      def payload
        monitors.reduce({}) do |data, monitor|
          data.merge(monitor.key => monitor.measure)
        end
      end

      def monitors
        @monitors ||= RailsPerformance.system_monitors.map do |class_name|
          RailsPerformance::Widgets.const_get(class_name).new(nil)
        end
      end

      def run
        store_data(payload)
      end

      def store_data(data)
        ::Rails.logger.info("Server: #{server_id}, Context: #{context}, Role: #{role}, data: #{data}")

        now = RailsPerformance::Utils.kind_of_now
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
