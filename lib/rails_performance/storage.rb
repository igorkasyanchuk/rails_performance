module RailsPerformance
  module Storage
    # config.storage = :redis_store, {url: "redis://..."}
    # config.storage = :active_record_store
    # config.storage = MyStore.new
    def self.lookup_store(store = nil, *args)
      case store
      when Symbol, String
        options = args.extract_options!
        const_get(store.to_s.camelize).new(*args, **options)
      when nil
        RedisStore.new
      else
        store
      end
    end

    # queries made by the storage itself should not be traced
    def self.silence
      silenced = Thread.current[:rp_storage_silenced]
      Thread.current[:rp_storage_silenced] = true
      yield
    ensure
      Thread.current[:rp_storage_silenced] = silenced
    end

    def self.silenced?
      !!Thread.current[:rp_storage_silenced]
    end
  end
end
