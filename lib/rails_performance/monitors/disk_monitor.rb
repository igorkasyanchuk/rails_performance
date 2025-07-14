module RailsPerformance
  module Monitors
    class DiskMonitor
      def call
        {disk: payload}
      end

      private

      def payload
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
