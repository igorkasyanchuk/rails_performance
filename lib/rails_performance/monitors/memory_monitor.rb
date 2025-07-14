module RailsPerformance
  module Monitors
    class MemoryMonitor
      def call
        {memory: payload}
      end

      private

      def payload
        GetProcessMem.new.bytes
      rescue => e
        ::Rails.logger.error "Error fetching memory usage: #{e.message}"
        0
      end
    end
  end
end
