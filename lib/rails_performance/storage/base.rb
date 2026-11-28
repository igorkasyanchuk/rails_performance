module RailsPerformance
  module Storage
    class Base
      # value is a JSON string
      def write(key, value, expires_in:)
        raise NotImplementedError
      end

      # returns a String or nil
      def read(key)
        raise NotImplementedError
      end

      # returns [keys, values] for keys matching a Redis-like glob pattern, or [] if nothing found
      # pattern always starts with a record type, e.g. "performance|*|request_id|123|*"
      def fetch(pattern)
        raise NotImplementedError
      end

      def clear
        raise NotImplementedError
      end

      # remove expired records, only needed for stores without native expiration
      def cleanup
      end
    end
  end
end
