class Metrics

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

    record = {
      controller: event.payload[:controller],
      action: event.payload[:action],
      format: event.payload[:format],
      method: event.payload[:method],
      path: event.payload[:path],
      status: event.payload[:status],
      view_runtime: event.payload[:view_runtime],
      db_runtime: event.payload[:db_runtime],
      duration: event.duration
    }

    namespace = "metrics|#{record[:controller]}|#{record[:action]}|#{finished.strftime("%Y%m%dT%H%M")}|#{finished.to_i}|#{record[:path]}"

    # set("#{namespace}|all", record.to_json)
    # set("#{namespace}|database", record[:db_runtime])
    # set("#{namespace}|view_duration", record[:view_runtime])
    set("#{namespace}|total_duration", record[:duration])
  end

  def set(key, value)
    #puts "#{key} = #{value}"
    RailsPerformance.redis.set(key, value)
    RailsPerformance.redis.expire(key, RailsPerformance.duration.to_i)
  end
end