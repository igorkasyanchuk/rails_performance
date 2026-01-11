module RailsPerformance
  module Widgets
    class Base
      attr_reader :datasource

      def initialize(datasource)
        @datasource = datasource
      end

      def to_partial_path
        raise NotImplementedError
      end
    end
  end
end
