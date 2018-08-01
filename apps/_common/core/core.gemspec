$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "core"
  s.version     = Core::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of Core."
  s.description = "Description of Core."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
end
