module RailsPerformance
  module Models
    class RequestRecord < BaseRecord
      attr_accessor :controller, :action, :format, :status, :datetime, :datetimei, :method, :path, :request_id, :json
      attr_accessor :view_runtime, :db_runtime, :duration, :http_referer, :custom_data
      attr_accessor :exception, :exception_object

      def RequestRecord.find_by(request_id:)
        keys, values = RailsPerformance::Utils.fetch_from_redis("performance|*|request_id|#{request_id}|*")

        return nil if keys.blank?
        return nil if values.blank?

        RailsPerformance::Models::RequestRecord.from_db(keys[0], values[0])
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
      # END|1.0.0
      # = {"view_runtime":null,"db_runtime":0,"duration":27.329741000000002,"http_referer":null,"custom_data":null,"exception":"ZeroDivisionError divided by 0","backtrace":["/root/projects/rails_performance/test/dummy/app/controllers/account/site_controller.rb:17:in `/'","/root/projects/rails_performance/test/dummy/app/controllers/account/site_controller.rb:17:in `crash'","/usr/local/rvm/gems/ruby-2.6.3/gems/actionpack-6.1.3.1/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'"]}
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

      def initialize(controller:, action:, format:, status:, datetime:, datetimei:, method:, path:, request_id:, view_runtime: nil, db_runtime: nil, duration: nil, http_referer: nil, custom_data: nil, exception: nil, exception_object: nil, json: '{}')
        @controller   = controller
        @action       = action
        @format       = format
        @status       = status
        @datetime     = datetime
        @datetimei    = datetimei.to_i
        @method       = method
        @path         = path
        @request_id   = request_id

        @view_runtime = view_runtime
        @db_runtime   = db_runtime
        @duration     = duration
        @http_referer = http_referer
        @custom_data  = custom_data

        @exception        = Array.wrap(exception).compact.join(" ")
        @exception_object = exception_object

        @json         = json
      end

      def controller_action
        "#{controller}##{action}"
      end

      def controller_action_format
        "#{controller}##{action}|#{format}"
      end

      # show on UI in the right panel
      def record_hash
        {
          controller: self.controller,
          action: self.action,
          format: self.format,
          status: self.status,
          method: self.method,
          path: self.path,
          request_id: self.request_id,
          datetime: Time.at(self.datetimei.to_i),
          datetimei: datetimei,
          duration: self.value['duration'],
          db_runtime: self.value['db_runtime'],
          view_runtime: self.value['view_runtime'],
          exception: self.value['exception'],
          backtrace: self.value['backtrace'],
          http_referer: self.value['http_referer']
        }.tap do |h|
          custom_data = JSON.parse(self.value['custom_data']) rescue nil
          if custom_data.is_a?(Hash)
            h.merge!(custom_data)
          end
        end
      end

      def save
        key   = "performance|controller|#{controller}|action|#{action}|format|#{format}|status|#{status}|datetime|#{datetime}|datetimei|#{datetimei}|method|#{method}|path|#{path}|request_id|#{request_id}|END|#{RailsPerformance::SCHEMA}"
        value = {
          view_runtime: view_runtime,
          db_runtime: db_runtime,
          duration: duration,
          http_referer: http_referer,
          custom_data: custom_data.to_json
        }
        value[:exception] = exception if exception.present?
        value[:backtrace] = exception_object.backtrace.take(3) if exception_object
        Utils.save_to_redis(key, value)
      end

    end
  end
end
