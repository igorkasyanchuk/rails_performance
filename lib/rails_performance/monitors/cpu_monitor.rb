module RailsPerformance
  module Monitors
    class CPUMonitor
      def call
        { cpu: payload }
      end

      private

      def payload
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
  end
end

