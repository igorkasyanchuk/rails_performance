module RailsPerformance
  class CurrentRequest < ActiveSupport::CurrentAttributes
    attribute :request_id, :tracings, :ignore
    attribute :data, :record

    # Auto-Cleanup
    resets { RailsPerformance.skip = false }

    # Set defaults
    def request_id
      super || self.request_id = SecureRandom.hex(16)
    end

    def tracings
      super || self.tracings = []
    end

    def ignore
      super || self.ignore = Set.new
    end

    class << self
      # Trace request
      def trace(options = {})
        tracings << options.merge(time: RailsPerformance::Utils.time.to_i)
      end
    end
  end
end
