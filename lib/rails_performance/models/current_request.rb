module RailsPerformance
  class CurrentRequest
    attr_reader :request_id, :storage
    attr_accessor :record

    def CurrentRequest.init
      Thread.current[:rp_current_request] ||= CurrentRequest.new(SecureRandom.hex(16))
    end

    def CurrentRequest.current
      CurrentRequest.init
    end

    def CurrentRequest.cleanup
      Thread.current[:rp_current_request] = nil
    end

    def initialize(request_id)
      @request_id = request_id
      @storage    = []
      @record     = nil
    end

    def store(options = {})
      @storage << options.merge(time: Time.now.to_i)
    end

  end
end