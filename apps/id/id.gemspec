$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "id"
  s.version     = Id::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Id."
  s.description = "Description of Id."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # OAuth 2 provider
  s.add_dependency 'doorkeeper'

  # User authentication
  s.add_dependency 'devise'
  s.add_dependency 'devise-doorkeeper'

  #### Shared Engine Gems ####

  s.add_dependency "core"
  s.add_dependency "ui"

end
