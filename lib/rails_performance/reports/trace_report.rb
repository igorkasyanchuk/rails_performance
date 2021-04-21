module RailsPerformance
  module Reports
    class TraceReport
      attr_reader :request_id

      def initialize(request_id:)
        @request_id = request_id
      end

      def data
        key   = "trace|#{request_id}|END|#{RailsPerformance::SCHEMA}"
        JSON.parse(RailsPerformance.redis.get(key).presence || '[]')
      end
    end


  end
end