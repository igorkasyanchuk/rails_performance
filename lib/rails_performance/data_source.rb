module RailsPerformance
  class DataSource
    attr_reader :q

    def initialize(q: {})
      q[:on] ||= Date.today
      @q       = q

      #puts "  [DataSource Q]  -->  #{@q.inspect}\n\n"
    end

    def db
      result = RP::Models::Collection.new
      (RP::Utils.days + 1).times do |e|
        RP::DataSource.new(q: self.q.merge({ on: e.days.ago.to_date })).add_to(result)
      end
      result
    end

    def default?
      @q.keys == [:on]
    end

    def add_to(storage = RP::Models::Collection.new)
      store do |record|
        storage.add(record)
      end
      storage
    end

    def store
      puts "\n\n   [REDIS QUERY]   -->   #{query}\n\n"

      keys   = RP.redis.keys(query)
      return [] if keys.blank?
      values = RP.redis.mget(keys)

      keys.each_with_index do |key, index|
        yield RP::Models::Record.new(key, values[index])
      end
    end

    private

    # key = performance|
    # controller|HomeController|
    # action|index|
    # format|html|
    # status|200|
    # datetime|20200124T0523|
    # datetimei|1579861423|
    # method|GET|
    # path|/|
    # END

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
      "performance|*#{compile_query}*|END"
    end

  end
end