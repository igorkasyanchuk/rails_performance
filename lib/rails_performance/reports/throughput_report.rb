module RailsPerformance
  module Reports
    class ThroughputReport < BaseReport

      def set_defaults
        @group ||= :datetime
      end

      def data
        calculate_data do |all, k, v|
          all[k] = v.count
        end
      end

    end
  end
end
