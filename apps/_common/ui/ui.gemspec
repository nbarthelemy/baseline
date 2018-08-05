$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ui/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ui"
  s.version     = Ui::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Ui."
  s.description = "Description of Ui."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # Use SCSS for stylesheets
  s.add_dependency 'sass-rails'

  # Use Uglifier as compressor for JavaScript assets
  s.add_dependency 'uglifier'

  # Use CoffeeScript for .js.coffee assets and views
  s.add_dependency 'coffee-rails'

  # A gem to automate using jQuery with Rails
  s.add_dependency 'jquery-rails'

end
