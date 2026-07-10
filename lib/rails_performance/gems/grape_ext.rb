module RailsPerformance
  module Gems
    class GrapeExt
      def self.init
        ActiveSupport::Notifications.subscribe(/grape/) do |name, start, finish, id, payload|
          # TODO change to set
          CurrentRequest.ignore.add(:performance)

          now = RailsPerformance::Utils.time
          CurrentRequest.data ||= {}
          CurrentRequest.record ||= RailsPerformance::Models::GrapeRecord.new(request_id: CurrentRequest.request_id)
          CurrentRequest.record.datetimei ||= now.to_i
          CurrentRequest.record.datetime ||= now.strftime(RailsPerformance::FORMAT)

          if ["endpoint_render.grape", "endpoint_run.grape", "format_response.grape"].include?(name)
            CurrentRequest.record.send(name.tr(".", "_") + "=", (finish - start) * 1000)
          end

          if payload[:env]
            CurrentRequest.record.status = payload[:env]["api.endpoint"].status
            CurrentRequest.record.format = payload[:env]["api.format"]
            CurrentRequest.record.method = payload[:env]["REQUEST_METHOD"]
            CurrentRequest.record.path = payload[:env]["PATH_INFO"]
          end

          expects_no_content = Rack::Utils::STATUS_WITH_NO_ENTITY_BODY.include?(CurrentRequest.record.status)
          if name == "format_response.grape" ||
              (name == "endpoint_run.grape" && (payload[:endpoint]&.body.nil? || expects_no_content))
            CurrentRequest.record.save
          end
        end
      end
    end
  end
end
