module RailsPerformance
  module DashboardCharts
    class Base
      attr_reader :datasource

      def initialize(datasource)
        @datasource = datasource
      end

      def id
        raise NotImplementedError
      end

      def type
        raise NotImplementedError
      end

      def subtitle
        raise NotImplementedError
      end

      def description
        raise NotImplementedError
      end

      def legend
        raise NotImplementedError
      end

      def units
        nil
      end

      def data
        raise NotImplementedError
      end

      def card?
        false
      end
    end

    def card?
      false
    end
  end
end
