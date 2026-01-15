module RailsPerformance
  module Widgets
    class Chart < Base
      attr_accessor :subtitle, :description, :legend, :units

      def initialize(datasource, subtitle: nil, description: nil, legend: nil, units: nil)
        super(datasource)
        @subtitle = subtitle
        @description = description
        @legend = legend
        @units = units
      end

      def id
        raise NotImplementedError
      end

      def type
        raise NotImplementedError
      end

      def data
        raise NotImplementedError
      end

      def to_partial_path
        "rails_performance/rails_performance/chart"
      end
    end
  end
end
