require "rails/generators/active_record"

class RailsPerformance::ActiveRecordStoreGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates", __dir__)
  desc "Generates migration for rails_performance ActiveRecord storage"

  class_option :database, type: :string, aliases: %i[--db], desc: "The database for your migration. By default, the current environment's primary database is used."

  def copy_migration
    migration_template "create_rails_performance_entries.rb.tt", File.join(db_migrate_path, "create_rails_performance_entries.rb")
  end
end
