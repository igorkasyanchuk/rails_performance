module RailsPerformance
  module Gems
    class Grape

      def self.register_subscribers
        ActiveSupport::Notifications.subscribe(/grape/) do |name, start, finish, id, payload|
          # TODO change to set
          CurrentRequest.current.ignore.push(:performance)
          puts name
          #binding.pry

          now                                           = Time.now
          CurrentRequest.current.record               ||= {}
          CurrentRequest.current.record[:created_ati] ||= now.to_i
          CurrentRequest.current.record[:datetime]    ||= now.strftime(RailsPerformance::FORMAT)
          CurrentRequest.current.record[name]           = finish - start
          if payload[:env]
            CurrentRequest.current.record[:status]      = payload[:env]['api.endpoint'].status
            CurrentRequest.current.record[:format]      = payload[:env]["api.format"]
            CurrentRequest.current.record[:method]      = payload[:env]['REQUEST_METHOD']
            CurrentRequest.current.record[:path]        = payload[:env]["PATH_INFO"]
          end
          CurrentRequest.current.record[:request_id]    = CurrentRequest.current.request_id

          if name == 'format_response.grape'
            Utils.log_grape_request_in_redis(CurrentRequest.current.record)
          end
        end
      end

    end
  end
end
