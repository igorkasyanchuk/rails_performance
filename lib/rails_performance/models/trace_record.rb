module RailsPerformance
  module Models
    class TraceRecord < BaseRecord
      attr_accessor :request_id, :value

      def initialize(request_id:, value:)
        @request_id = request_id
        @value      = value
      end

      def save
        return if value.empty?

        Utils.save_to_redis("trace|#{request_id}|END|#{RailsPerformance::SCHEMA}", value, RailsPerformance.recent_requests_time_window.to_i)
      end

    end
  end
end
