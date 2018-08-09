$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "identity/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "Identity"
  s.version     = Identity::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Identity."
  s.description = "Description of Identity."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # needed for our oauth2 client
  s.add_dependency "omniauth-oauth2", "~> 1.5.0"

end
