module RailsPerformance
  module Reports
    class ThroughputReport < BaseReport

      def set_defaults
        @group ||= :datetime
      end

      # def prepare_query(query = {})
      #   RailsPerformance::Rails::QueryBuilder.compose_from({})
      # end
      # @datasource                = RailsPerformance::DataSource.new(**prepare_query({}), type: :requests)
      # db                         = @datasource.db
      # RailsPerformance::Reports::ThroughputReport.new(db).data
      # Time.at(RailsPerformance::Reports::ThroughputReport.new(db).data.last[0] / 1000)

      def data
        calculate_data do |all, k, v|
          all[k] = v.count
        end
      end

    end
  end
end
