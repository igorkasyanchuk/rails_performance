module RailsPerformance
  module Models
    class Collection
      attr_reader :data

      def initialize
        @data = []
      end

      def add(record)
        @data << record
      end

      def group_by(type)
        case type
        when :controller_action, :controller_action_format, :datetime, :path
          fetch_values @data.group_by(&type)
        else
          {}
        end
      end

      def fetch_values(groupped_collection)
        result = {}
        groupped_collection.each do |key, records|
          result[key] ||= []
          records.each do |record|
            result[key] << record.value
          end
        end
        result
      end

    end
  end
end