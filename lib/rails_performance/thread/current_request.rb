module RailsPerformance
  class CurrentRequest
    attr_reader :request_id, :tracings, :ignore
    attr_accessor :data
    attr_accessor :record

    def CurrentRequest.init
      Thread.current[:rp_current_request] ||= CurrentRequest.new(SecureRandom.hex(16))
    end

    def CurrentRequest.current
      CurrentRequest.init
    end

    def CurrentRequest.cleanup
      RailsPerformance.log "----------------------------------------------------> CurrentRequest.cleanup !!!!!!!!!!!! -------------------------\n\n"
      RailsPerformance.skip = false
      Thread.current[:rp_current_request] = nil
    end

    def initialize(request_id)
      @request_id = request_id
      @tracings   = []
      @ignore     = Set.new
      @data       = nil
      @record     = nil
    end

    def trace(options = {})
      @tracings << options.merge(time: Time.current.to_i)
    end

  end
end
