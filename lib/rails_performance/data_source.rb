module RailsPerformance
  class DataSource
    attr_reader :q

    def initialize(q: {})
      q[:on] ||= Date.current
      @q       = q
    end

    def DataSource.all
      result = RP::Collection.new
      RP::Utils.days.times do |e|
        RP::DataSource.new(q: { on: e.days.ago.to_date }).add_to(result)
      end
      result
    end

    # key = performance|
    # controller|HomeController|
    # action|index|
    # format|html|
    # status|200|
    # datetime|20200124T0523|
    # datetimei|1579861423|
    # method|GET|
    # path|/|
    # duration 

    def compile_query
      str = []
      
      str << "controller|#{q[:controller]}|" if q[:controller].present?
      str << "action|#{q[:action]}|" if q[:action].present?
      str << "format|#{q[:format]}|" if q[:format].present?
      str << "status|#{q[:status]}|" if q[:status].present?

      str << "datetime|#{q[:on].strftime('%Y%m%d')}*|" if q[:on].present?
      
      str << "method|#{q[:method]}|" if q[:method].present?
      str << "path|#{q[:path]}|" if q[:path].present?

      str.join("*")
    end

    def query
      "performance|*#{compile_query}*|*duration"
    end

    def collection(storage = RP::Collection.new)
      collect do |record|
        storage.add(record)
      end
      storage
    end
    alias :add_to :collection

    def collect
      puts "REDIS: #{query}"

      keys   = RP.redis.keys(query)
      return [] if keys.blank?
      values = RP.redis.mget(keys)

      keys.each_with_index do |key, index|
        yield RP::Record.new(key, values[index])
      end
    end

  end
end