module RailsPerformance
  module Reports
    class ResponseTimeReport < BaseReport
      def set_defaults
        @group ||= :datetime
      end

      def data
        calculate_data do |all, k, v|
          durations = v.collect{|e| e["duration"]}.compact
          next if durations.empty?
          all[k] = durations.sum.to_f / durations.count
        end
      end
    end
  end
end
