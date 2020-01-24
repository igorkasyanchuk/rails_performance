module RailsPerformance
  class Collection
    attr_reader :data

    def initialize
      @data = []
    end

    def add(record)
      @data << record
    end

    def group_by(type)
      @data = case type
      when :controller_action, :controller_action_format, :datetime, :path
        data.group_by(&type)
      else
        []
      end
      self
    end

    def values
      return [] if @data.empty?
      result = {}
      @data.each do |key, records|
        result[key] ||= []
        records.each do |record|
          result[key] << record.value
        end
      end
      result
    end

  end
end