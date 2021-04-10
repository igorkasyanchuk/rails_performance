module RailsPerformance
  class CurrentRequest
    attr_reader :request_id, :storage, :ignore
    attr_accessor :record

    def CurrentRequest.init
      Thread.current[:rp_current_request] ||= CurrentRequest.new(SecureRandom.hex(16))
    end

    def CurrentRequest.current
      CurrentRequest.init
    end

    def CurrentRequest.cleanup
      RailsPerformance.log "----------------------------------------------------> CurrentRequest.cleanup !!!!!!!!!!!! -------------------------\n\n"
      Thread.current[:rp_current_request] = nil
    end

    def initialize(request_id)
      @request_id = request_id
      @storage    = []
      @record     = nil
      @ignore     = []
    end

    def store(options = {})
      @storage << options.merge(time: Time.now.to_i)
    end

  end
end