$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "app/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "app"
  s.version     = App::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of App."
  s.description = "Description of App."

  s.files = Dir["{app,config,db,lib}/**/*", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
  s.add_dependency 'turbolinks', '~> 5'

  # Breacrumb management in the ui. See: https://github.com/lassebunk/gretel
  s.add_dependency 'gretel'

  # Make forms suck less. See: https://github.com/bootstrap-ruby/bootstrap_form
  s.add_dependency 'bootstrap_form', '>= 4.0.0.alpha1'

  #### Shared Engine Gems ####

  s.add_dependency "core"
  s.add_dependency "ui"
  s.add_dependency "identity"

end
