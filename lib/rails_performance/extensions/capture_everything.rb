module RailsPerformance
  module Extensions
    module View

      def info(&block)
        CurrentRequest.current.store({
          group: :view,
          message: {
            message: block.call 
          }
        })
        super(&block)
      end

    end
  end
end

module RailsPerformance
  module Extensions
    module Db

      def sql(event)
        CurrentRequest.current.store({
          group: :db,
          message: {
            duration: event.duration.round(2),
            sql: event.payload[:sql]
          }
        })
        super(event)
      end

    end
  end
end

