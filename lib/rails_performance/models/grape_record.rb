module RailsPerformance
  module Models
    class GrapeRecord < BaseRecord
      attr_accessor :datetime, :datetimei, :format, :status, :path, :method, :request_id, :json
      attr_accessor :endpoint_render_grape, :endpoint_run_grape, :format_response_grape

      # key = grape|datetime|20210409T1115|datetimei|1617992134|format|json|path|/api/users|status|200|method|GET|request_id|1122|END|1.0.0
      # value = {"endpoint_render.grape"=>0.000643989, "endpoint_run.grape"=>0.002000907, "format_response.grape"=>0.0348967}
      def GrapeRecord.from_db(key, value)
        items = key.split("|")

        GrapeRecord.new(
          datetime: items[2],
          datetimei: items[4],
          format: items[6],
          path: items[8],
          status: items[10],
          method: items[12],
          request_id: items[14],
          json: value
        )
      end

      def initialize(datetime: nil, datetimei: nil, format: nil, path: nil, status: nil, method: nil, request_id:, endpoint_render_grape: nil, endpoint_run_grape: nil, format_response_grape: nil, json: '{}')
        @datetime     = datetime
        @datetimei    = datetimei.to_i unless datetimei.nil?
        @format       = format
        @path         = path
        @status       = status
        @method       = method
        @request_id   = request_id

        @endpoint_render_grape = endpoint_render_grape
        @endpoint_run_grape    = endpoint_run_grape
        @format_response_grape = format_response_grape

        @json         = json
      end

      def record_hash
        {
          format: self.format,
          status: self.status,
          method: self.method,
          path: self.path,
          datetime: Time.at(self.datetimei.to_i),
          datetimei: datetimei.to_i,
          request_id: self.request_id,
        }.merge(self.value)
      end

      def save
        key   = "grape|datetime|#{datetime}|datetimei|#{datetimei}|format|#{format}|path|#{path}|status|#{status}|method|#{method}|request_id|#{request_id}|END|#{RailsPerformance::SCHEMA}"
        value = { "endpoint_render.grape" => endpoint_render_grape, "endpoint_run.grape" => endpoint_run_grape, "format_response.grape" => format_response_grape }

        Utils.save_to_redis(key, value)
      end

    end
  end
end