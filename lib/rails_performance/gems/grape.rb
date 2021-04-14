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
          CurrentRequest.current.data               ||= {}
          CurrentRequest.current.data[:created_ati] ||= now.to_i
          CurrentRequest.current.data[:datetime]    ||= now.strftime(RailsPerformance::FORMAT)
          CurrentRequest.current.data[name]           = finish - start
          if payload[:env]
            CurrentRequest.current.data[:status]      = payload[:env]['api.endpoint'].status
            CurrentRequest.current.data[:format]      = payload[:env]["api.format"]
            CurrentRequest.current.data[:method]      = payload[:env]['REQUEST_METHOD']
            CurrentRequest.current.data[:path]        = payload[:env]["PATH_INFO"]
          end
          CurrentRequest.current.data[:request_id]    = CurrentRequest.current.request_id

          if name == 'format_response.grape'
            Utils.log_grape_request_in_redis(CurrentRequest.current.data)
          end
        end
      end

    end
  end
end
