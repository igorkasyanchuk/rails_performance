module RailsPerformance
  module Extensions
    module View
      # in env
      # this works if config.log_level = :info
      def info(&block)
        CurrentRequest.trace({
          group: :view,
          message: block.call
        })
        super
      end
    end
  end
end
