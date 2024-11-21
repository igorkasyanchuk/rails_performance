module RailsPerformance
  module Gems
    module CustomExtension
      extend self

      def measure(tag_name, namespace_name = nil)
        return yield unless RailsPerformance.enabled
        return yield unless RailsPerformance.include_custom_events

        begin
          now = RailsPerformance::Utils.time
          status = "success"
          result = yield
          result
        rescue Exception => ex # rubocop:disable Lint/RescueException
          status = "error"
          raise(ex)
        ensure
          RailsPerformance::Models::CustomRecord.new(
            tag_name: tag_name,
            namespace_name: namespace_name,
            status: status,
            duration: (RailsPerformance::Utils.time - now) * 1000,
            datetime: now.strftime(RailsPerformance::FORMAT),
            datetimei: now.to_i
          ).save
        end
      end
    end
  end
end
