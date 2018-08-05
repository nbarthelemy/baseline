$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "sso/client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sso-client"
  s.version     = Sso::Client::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Sso::Client."
  s.description = "Description of Sso::Client."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
end
