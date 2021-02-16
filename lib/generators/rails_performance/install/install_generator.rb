class RailsPerformance::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  desc "Generates initial config for rails_performance gem"

  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/rails_performance.rb"
  end
end
