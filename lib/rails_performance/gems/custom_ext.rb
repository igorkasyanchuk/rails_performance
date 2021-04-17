module RailsPerformance
  module Gems
    module CustomExtension
      def measure_rails_performance(tag_name, namespace = "")
        return yield unless RailsPerformance.enabled

        begin
          now    = Time.now
          result = yield
          status = 'success'
          result
        rescue Exception => ex
          status = 'error'
          raise(ex)
        ensure
          puts Time.now - now
          result
        end
      end

    end
  end
end

self.send :extend, RailsPerformance::Gems::CustomExtension