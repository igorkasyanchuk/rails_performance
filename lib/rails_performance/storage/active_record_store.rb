module RailsPerformance
  module Storage
    # requires the table from `rails generate rails_performance:active_record_store`
    class ActiveRecordStore < Base
      CLEANUP_EVERY = 1000

      attr_reader :database, :cleanup_every

      def initialize(database: nil, cleanup_every: CLEANUP_EVERY)
        @database = database
        @cleanup_every = cleanup_every
        @mutex = Mutex.new
        @model = nil
      end

      # errors are logged, so monitoring never breaks the app
      def write(key, value, expires_in:)
        Storage.silence do
          within_savepoint do
            model.upsert(
              {
                key: key,
                key_digest: digest(key),
                bucket: Index.bucket_for(key),
                value: value,
                expires_at: Time.current + expires_in.to_i
              },
              **upsert_options
            )
          end
          cleanup if rand(cleanup_every).zero?
        end
      rescue ActiveRecord::ActiveRecordError => e
        ::Rails.logger&.error "RailsPerformance storage error: #{e.message}"
        nil
      end

      def read(key)
        Storage.silence do
          model.not_expired.where(key_digest: digest(key)).pick(:value)
        end
      end

      def fetch(pattern)
        buckets = Index.buckets_for(pattern)
        return [] if buckets.empty?

        rows = Storage.silence do
          model.not_expired
            .where(bucket: buckets)
            .where(model.arel_table[:key].matches(like_pattern(pattern), "\\", true))
            .pluck(:key, :value)
        end
        rows = rows.select { |key, _| Index.match?(pattern, key) }
        return [] if rows.empty?

        rows.transpose
      end

      def clear
        Storage.silence { model.delete_all }
      end

      def cleanup
        Storage.silence do
          model.where(expires_at: ..Time.current).in_batches(of: 1000).delete_all
        end
      end

      def model
        @model || @mutex.synchronize do
          @model ||= begin
            require_relative "entry"
            Record.connects_to(database: {writing: database, reading: database}) if database
            Entry
          end
        end
      end

      private

      # a failed query must not abort the app's transaction (PostgreSQL)
      def within_savepoint(&block)
        if model.connection_pool.active_connection&.transaction_open?
          model.transaction(requires_new: true, &block)
        else
          yield
        end
      end

      # MySQL doesn't support :unique_by and uses any unique index instead
      def upsert_options
        @upsert_options ||= model.connection_pool.with_connection(&:supports_insert_conflict_target?) ? {unique_by: :key_digest} : {}
      end

      def digest(key)
        Digest::SHA256.hexdigest(key)
      end

      # LIKE only narrows down the rows, exact matching is done by Index.match?
      def like_pattern(pattern)
        pattern.gsub(/\\.?|\[[^\]]*\]|[*?%_]/) do |token|
          case token
          when "*" then "%"
          when "?" then "_"
          when "%", "_" then "\\#{token}"
          else
            token.start_with?("[") ? "_" : like_escape(token[1] || "\\")
          end
        end
      end

      def like_escape(char)
        char.match?(/[%_\\]/) ? "\\#{char}" : char
      end
    end
  end
end
