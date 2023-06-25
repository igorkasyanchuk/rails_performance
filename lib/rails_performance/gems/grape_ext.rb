module RailsPerformance
  module Gems
    class GrapeExt

      def self.init
        ActiveSupport::Notifications.subscribe(/grape/) do |name, start, finish, id, payload|
          # TODO change to set
          CurrentRequest.current.ignore.add(:performance)

          now                                         = Time.current
          CurrentRequest.current.data               ||= {}
          CurrentRequest.current.record             ||= RailsPerformance::Models::GrapeRecord.new(request_id: CurrentRequest.current.request_id)
          CurrentRequest.current.record.datetimei   ||= now.to_i
          CurrentRequest.current.record.datetime    ||= now.strftime(RailsPerformance::FORMAT)

          if ['endpoint_render.grape', 'endpoint_run.grape', 'format_response.grape'].include?(name)
            CurrentRequest.current.record.send(name.gsub(".", "_") + "=", (finish - start) * 1000)
          end

          if payload[:env]
            CurrentRequest.current.record.status      = payload[:env]['api.endpoint'].status
            CurrentRequest.current.record.format      = payload[:env]["api.format"]
            CurrentRequest.current.record.method      = payload[:env]['REQUEST_METHOD']
            CurrentRequest.current.record.path        = payload[:env]["PATH_INFO"]
          end

          if name == 'format_response.grape'
            CurrentRequest.current.record.save
          end
        end
      end

    end
  end
end
