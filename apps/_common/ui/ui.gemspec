$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ui/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ui"
  s.version     = Ui::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of Ui."
  s.description = "Description of Ui."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
end
