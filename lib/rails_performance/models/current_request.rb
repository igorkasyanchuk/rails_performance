module RailsPerformance
  class CurrentRequest
    attr_reader :request_id, :storage

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
    end

    def store(group:, message:)
      @storage << { group: group, message: message, time: Time.now.to_i }
    end

  end
end