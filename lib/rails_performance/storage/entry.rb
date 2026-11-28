module RailsPerformance
  module Storage
    class Record < ::ActiveRecord::Base
      self.abstract_class = true
    end

    class Entry < Record
      self.table_name = "rails_performance_entries"

      scope :not_expired, -> { where("expires_at > ?", Time.current) }
    end
  end
end
