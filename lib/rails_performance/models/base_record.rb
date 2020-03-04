module RailsPerformance
  module Models
    class BaseRecord
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