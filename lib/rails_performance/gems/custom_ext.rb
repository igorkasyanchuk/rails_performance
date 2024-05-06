module RailsPerformance
  module Gems
    module CustomExtension
      extend self

      def measure(tag_name, namespace_name = nil)
        return yield unless RailsPerformance.enabled
        return yield unless RailsPerformance.include_custom_events

        begin
          now    = Time.current
          status = 'success'
          result = yield
          result
        rescue Exception => ex
          status = 'error'
          raise(ex)
        ensure
          RailsPerformance::Models::CustomRecord.new(
            tag_name: tag_name,
            namespace_name: namespace_name,
            status: status,
            duration: (Time.current - now) * 1000,
            datetime: now.strftime(RailsPerformance::FORMAT),
            datetimei: now.to_i,
          ).save

          result
        end
      end

    end
  end
end
