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

  # Use ActiveModel has_secure_password
  # s.add_dependency 'bcrypt', '~> 3.1.7'

  # Use devise for authentication. See: https://github.com/plataformatec/devise
  s.add_dependency 'devise'

  # Send Devise's emails in background. See: https://github.com/mhfs/devise-async
  s.add_dependency 'devise-async'

  # For resource authorization. See: https://github.com/varvet/pundit
  s.add_dependency 'pundit'

  # for handling name formatting. See: https://github.com/basecamp/name_of_person
  s.add_dependency 'name_of_person'

end
