module RailsPerformance
  class DataSource
    KLASSES = {
      requests: RailsPerformance::Models::RequestRecord,
      sidekiq: RailsPerformance::Models::SidekiqRecord,
      delayed_job: RailsPerformance::Models::DelayedJobRecord,
      grape: RailsPerformance::Models::GrapeRecord,
      rake: RailsPerformance::Models::RakeRecord,
      custom: RailsPerformance::Models::CustomRecord,
      resources: RailsPerformance::Models::ResourceRecord
    }

    attr_reader :q, :klass, :type, :days

    def initialize(type:, q: {}, days: RailsPerformance::Utils.days(RailsPerformance.duration))
      @type = type
      @klass = KLASSES[type]
      q[:on] ||= Date.today
      @q = q
      @days = days
    end

    def db
      result = RailsPerformance::Models::Collection.new
      now = RailsPerformance::Utils.time
      (0..days).to_a.reverse_each do |e|
        RailsPerformance::DataSource.new(q: q.merge({on: (now - e.days).to_date}), type: type).add_to(result)
      end
      result
    end

    def default?
      @q.keys == [:on]
    end

    def add_to(storage = RailsPerformance::Models::Collection.new)
      store do |record|
        storage.add(record)
      end
      storage
    end

    def store
      keys, values = Utils.fetch_from_redis(query)

      return [] if keys.blank?

      keys.each_with_index do |key, index|
        yield klass.from_db(key, values[index])
      end
    end

    private

    def query
      case type
      when :requests
        "performance|*#{compile_requests_query}*|END|#{RailsPerformance::SCHEMA}"
      when :resources
        "resource|*#{compile_resource_query}*|END|#{RailsPerformance::SCHEMA}"
      when :sidekiq
        "sidekiq|*#{compile_sidekiq_query}*|END|#{RailsPerformance::SCHEMA}"
      when :delayed_job
        "delayed_job|*#{compile_delayed_job_query}*|END|#{RailsPerformance::SCHEMA}"
      when :grape
        "grape|*#{compile_grape_query}*|END|#{RailsPerformance::SCHEMA}"
      when :rake
        "rake|*#{compile_rake_query}*|END|#{RailsPerformance::SCHEMA}"
      when :custom
        "custom|*#{compile_custom_query}*|END|#{RailsPerformance::SCHEMA}"
      else
        raise "wrong type: \"#{type}\" for datasource query builder"
      end
    end

    def compile_requests_query
      str = []
      str << "controller|#{q[:controller]}|" if q[:controller].present?
      str << "action|#{q[:action]}|" if q[:action].present?
      str << "format|#{q[:format]}|" if q[:format].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "method|#{q[:method]}|" if q[:method].present?
      str << "path|#{q[:path]}|" if q[:path].present?
      str.join("*")
    end

    def compile_sidekiq_query
      str = []
      str << "queue|#{q[:queue]}|" if q[:queue].present?
      str << "worker|#{q[:worker]}|" if q[:worker].present?
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str.join("*")
    end

    def compile_resource_query
      str = []
      str << "server|#{q[:server]}|" if q[:server].present?
      str << "context|#{q[:context]}|" if q[:context].present?
      str << "role|#{q[:role]}|" if q[:role].present?
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str.join("*")
    end

    def compile_delayed_job_query
      str = []
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str.join("*")
    end

    def compile_rake_query
      str = []
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str.join("*")
    end

    def compile_custom_query
      str = []
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str.join("*")
    end

    def compile_grape_query
      str = []
      str << "datetime|#{q[:on].strftime("%Y%m%d")}*|" if q[:on].present?
      str << "status|#{q[:status]}|" if q[:status].present?
      str.join("*")
    end
  end
end
