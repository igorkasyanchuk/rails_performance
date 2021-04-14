module RailsPerformance
  module Models
    class RequestRecord < BaseRecord
      attr_accessor :controller, :action, :format, :status, :datetime, :datetimei, :method, :path, :request_id, :json
      attr_accessor :view_runtime, :db_runtime, :duration, :http_referer

      def RequestRecord.find_by(request_id:)
        keys, values = RP::Utils.fetch_from_redis("performance|*|request_id|#{request_id}|*")

        return nil if keys.blank?
        return nil if values.blank?

        RP::Models::RequestRecord.from_db(keys[0], values[0])
      end

      # key = performance|
      # controller|HomeController|
      # action|index|
      # format|html|
      # status|200|
      # datetime|20200124T0523|
      # datetimei|1579861423|
      # method|GET|
      # path|/|
      # request_id|454545454545454545|
      # END
      # = {"view_runtime":8.444603008683771,"db_runtime":0,"duration":9.216095000000001}
      # value = JSON
      def RequestRecord.from_db(key, value)
        items = key.split("|")

        RequestRecord.new(
          controller: items[2],
          action: items[4],
          format: items[6],
          status: items[8],
          datetime: items[10],
          datetimei: items[12],
          method: items[14],
          path: items[16],
          request_id: items[18],
          json: value
        )
      end

      def initialize(controller:, action:, format:, status:, datetime:, datetimei:, method:, path:, request_id:, view_runtime: nil, db_runtime: nil, duration: nil, http_referer: nil, json: '{}')
        @controller = controller
        @action     = action
        @format     = format
        @status     = status
        @datetime   = datetime
        @datetimei  = datetimei
        @method     = method
        @path       = path
        @request_id = request_id

        @view_runtime = view_runtime
        @db_runtime   = db_runtime
        @duration     = duration
        @http_referer = http_referer

        @json       = json
      end

      def controller_action
        "#{controller}##{action}"
      end

      def controller_action_format
        "#{controller}##{action}|#{format}"
      end

      def to_h
        {
          controller: controller,
          action: action,
          format: format,
          method: method,
          path: path,
          duration: ms(duration),
          view_runtime: ms(value['view_runtime']),
          db_runtime: ms(value['db_runtime']),
          http_referer: value['http_referer']
        }
      end

      def save
        value = { view_runtime: view_runtime, db_runtime: db_runtime, duration: duration, http_referer: http_referer }
        key   = "performance|controller|#{controller}|action|#{action}|format|#{format}|status|#{status}|datetime|#{datetime}|datetimei|#{datetimei}|method|#{method}|path|#{path}|request_id|#{request_id}|END"
        Utils.save_to_redis(key, value)
      end

    end
  end
end