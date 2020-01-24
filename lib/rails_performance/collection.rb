module RailsPerformance
  class Collection
    attr_reader :data

    def initialize
      @data = []
    end

    def group_by(type)
      @data = case type
      when :controller_action
        data.group_by(&:controller_action)
      when :path
        data.group_by(&:path)
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