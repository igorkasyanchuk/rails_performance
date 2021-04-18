module RailsPerformance
  module Models
    class BaseRecord
      def self.from_db(key, value)
        raise 'implement me'
      end

      def save
        raise 'implement me'
      end

      def record_hash
        raise 'implement me'
      end

      def value
        @value ||= JSON.parse(@json || "{}")
      end

      def duration
        value['duration']
      end

      private

      def ms(e)
        if e
          e.to_f.round(1).to_s + " ms"
        else
          nil
        end
      end

    end
  end
end