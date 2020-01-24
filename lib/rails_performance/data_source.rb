module RailsPerformance
  class DataSource
    attr_reader :q

    def initialize(q: {})
      q[:on] ||= Date.today
      @q       = q
    end

    def DataSource.all
      result = RP::Collection.new
      RP::Utils.days.times do |e|
        RP::DataSource.new(q: { on: e.days.ago.to_date }).add_to(result)
      end
      result
    end

    def db(storage = RP::Collection.new)
      store do |record|
        storage.add(record)
      end
      storage
    end
    alias :add_to :db

    def store
      #puts "\n\n   [REDIS]   -->   #{query}\n\n"

      keys   = RP.redis.keys(query)
      return [] if keys.blank?
      values = RP.redis.mget(keys)

      keys.each_with_index do |key, index|
        yield RP::Record.new(key, values[index])
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