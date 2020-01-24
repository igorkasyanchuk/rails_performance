$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rails_performance/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rails_performance"
  spec.version     = RailsPerformance::VERSION
  spec.authors     = ["Igor Kasyanchuk"]
  spec.email       = ["igorkasyanchuk@gmail.com"]
  spec.homepage    = "https://github.com/igorkasyanchuk/rails_performance"
  spec.summary     = "Track number of requests to your app"
  spec.description = "Track number of requests to your app"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"
  spec.add_dependency "redis"
  spec.add_dependency "redis-namespace"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "simplecov"
end
