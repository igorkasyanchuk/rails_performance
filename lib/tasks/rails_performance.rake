namespace :rails_performance do
  namespace :storage do
    desc "Remove expired records from RailsPerformance storage"
    task cleanup: :environment do
      RailsPerformance.storage.cleanup
    end
  end
end
