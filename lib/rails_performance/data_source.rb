module RailsPerformance
  class DataSource
    attr_reader :q, :klass, :type

    def initialize(q: {}, type:, klass:)
      @klass   = klass
      @type    = type
      q[:on] ||= Date.today
      @q       = q

      #puts "  [DataSource Q]  -->  #{@q.inspect}\n\n"
    end

    def db
      result = RP::Models::Collection.new
      (RP::Utils.days + 1).times do |e|
        RP::DataSource.new(q: self.q.merge({ on: e.days.ago.to_date }), klass: klass, type: type).add_to(result)
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
      keys, values = Utils.fetch_from_redis(query)

      return [] if keys.blank?

      keys.each_with_index do |key, index|
        if type == :jobs || type == :requests
          yield klass.from_db(key, values[index])
        else
          yield klass.new(key, values[index])
        end
      end
    end

    private

    def query
      case type
      when :requests
        "performance|*#{compile_requests_query}*|END"
      when :jobs
        "jobs|*#{compile_jobs_query}*|END"
      when :grape
        "grape|*#{compile_jobs_query}*|END"
      else
        raise "wrong type for datasource query builder"
      end
    end

    def compile_requests_query
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

    def compile_jobs_query
      str = []

      str << "queue|#{q[:queue]}|" if q[:queue].present?
      str << "worker|#{q[:worker]}|" if q[:worker].present?
      str << "datetime|#{q[:on].strftime('%Y%m%d')}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?

      str.join("*")
    end

    def compile_grape_query
      str = []

      str << "datetime|#{q[:on].strftime('%Y%m%d')}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?

      str.join("*")
    end

  end
end