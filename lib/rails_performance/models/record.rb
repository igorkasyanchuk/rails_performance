module RailsPerformance
  module Models
    class Record
      attr_reader :controller, :action, :format, :status, :datetime, :datetimei, :method, :path, :request_id

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
      def initialize(key, value)
        @json = value

        items = key.split("|")

        @controller = items[2]
        @action     = items[4]
        @format     = items[6]
        @status     = items[8]
        @datetime   = items[10]
        @datetimei  = items[12]
        @method     = items[14]
        @path       = items[16]
        @request_id = items[18]
      end

      def value
        @value ||= JSON.parse(@json || "{}")
      end

      def controller_action
        "#{controller}##{action}"
      end

      def controller_action_format
        "#{controller}##{action}|#{format}"
      end
    end
  end
end