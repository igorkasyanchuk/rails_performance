module RailsPerformance
  module Extensions
    module View
      # in env
      # this works if config.log_level = :info
      def info(&block)
        CurrentRequest.current.trace({
          group: :view,
          message: block.call
        })
        super
      end
    end
  end
end

module RailsPerformance
  module Extensions
    module Db
      # in env
      # this works if config.log_level = :debug
      def sql(event)
        unless RailsPerformance::Storage.silenced?
          CurrentRequest.current.trace({
            group: :db,
            duration: event.duration.round(2),
            sql: event.payload[:sql]
          })
        end
        super
      end
    end
  end
end

module RailsPerformance
  module Extensions
    module StructuredDb
      # Rails 8.2+ passes a Hash event from ActiveSupport::EventReporter
      # this works if config.log_level = :debug
      def sql(event)
        payload = event[:payload]

        unless RailsPerformance::Storage.silenced?
          CurrentRequest.current.trace({
            group: :db,
            duration: payload[:duration_ms].round(2),
            sql: payload[:sql]
          })
        end
        super
      end
    end
  end
end
