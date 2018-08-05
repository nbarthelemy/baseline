$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "www/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "www"
  s.version     = Www::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of Www."
  s.description = "Description of Www."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  #### Shared Engine Gems ####

  s.add_dependency "core"

end