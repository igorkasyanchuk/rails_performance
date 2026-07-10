module RailsPerformance
  module Instrument
    class MetricsCollector
      # payload
      # {
      #   controller: "PostsController",
      #   action: "index",
      #   params: {"action" => "index", "controller" => "posts"},
      #   headers: #<ActionDispatch::Http::Headers:0x0055a67a519b88>,
      #   format: :html,
      #   method: "GET",
      #   path: "/posts",
      #   status: 200,
      #   view_runtime: 46.848,
      #   db_runtime: 0.157
      # }

      def call(event_name, started, finished, event_id, payload)
        return if RailsPerformance.skip
        return if CurrentRequest.data

        return if RailsPerformance.ignored_endpoints.include? "#{payload[:controller]}##{payload[:action]}"
        return if RailsPerformance.ignored_paths.any? { |p| payload[:path].start_with?(p) }

        finished = finished.utc

        record = {
          controller: payload[:controller],
          action: payload[:action],
          format: payload[:format],
          status: payload[:status],
          datetime: finished.strftime(RailsPerformance::FORMAT),
          datetimei: finished.to_i,
          method: payload[:method],
          path: payload[:path],
          view_runtime: payload[:view_runtime],
          db_runtime: payload[:db_runtime],
          duration: finished - started,
          exception: payload[:exception],
          exception_object: payload[:exception_object]
        }

        # pass the record to CurrentRequest
        # and saves later in middleware
        CurrentRequest.request_id = event_id
        CurrentRequest.data = record
      end
    end
  end
end
