module RailsPerformance
  module Reports
    class TraceReport
      attr_reader :request_id

      def initialize(request_id:)
        @request_id = request_id
      end

      def data
        key   = "trace|#{request_id}"
        JSON.parse(RP.redis.get(key).presence || '[]')
      end
    end


  end
end