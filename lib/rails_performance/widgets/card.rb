module RailsPerformance
  module Widgets
    class Card < Base
      def label
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end

      def to_partial_path
        "rails_performance/rails_performance/card"
      end
    end
  end
end
