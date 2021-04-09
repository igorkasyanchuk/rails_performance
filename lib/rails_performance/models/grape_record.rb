module RailsPerformance
  module Models
    class GrapeRecord < BaseRecord
      attr_reader :datetime, :created_ati, :datetime, :format, :status, :path, :method, :request_id

      # key = grape|datetime|20210409T1115|created_ati|1617992134|format|json|path|/api/users|status|200|method|GET|request_id|1122|END
      # value = {"endpoint_render.grape"=>0.000643989, "endpoint_run.grape"=>0.002000907, "format_response.grape"=>0.0348967}
      def initialize(key, value)
        @json = value

        items = key.split("|")

        @datetime     = items[2]
        @created_ati  = items[4]
        @format       = items[6]
        @path         = items[8]
        @status       = items[10]
        @method       = items[12]
        @request_id   = items[14]
      end

      def to_h
        {
          datetime: datetime,
          created_ati: created_ati,
          request_id: request_id,
          status: status,
          format: format,
          method: method,
          path: path,
          value: value
        }
      end

    end
  end
end