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
        event = ActiveSupport::Notifications::Event.new(event_name, started, finished, event_id, payload)

        return if %r{#{RailsPerformance.mount_at}}.match? event.payload[:path]
        return if RailsPerformance.ignored_endpoints.include? "#{event.payload[:controller]}##{event.payload[:action]}"

        record = {
          controller: event.payload[:controller],
          action: event.payload[:action],
          format: event.payload[:format],
          status: event.payload[:status],
          datetime: finished.strftime(RailsPerformance::FORMAT),
          datetimei: finished.to_i,
          method: event.payload[:method],
          path: event.payload[:path],
          view_runtime: event.payload[:view_runtime],
          db_runtime: event.payload[:db_runtime],
          duration: event.duration
        }

        CurrentRequest.current.record = record
      end
    end
  end
end
