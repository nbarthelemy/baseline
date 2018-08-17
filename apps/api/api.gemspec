$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api"
  s.version     = Api::VERSION
  s.authors     = ["Nick Barthelemy"]
  s.email       = ["nicholas.barthelemy@gmail.com"]
  s.summary     = "Summary of Api."
  s.description = "Description of Api."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  # A lightning fast JSON:API serializer. See https://github.com/Netflix/fast_jsonapi
  s.add_dependency "fast_jsonapi"

  # OAuth 2 provider
  s.add_dependency 'doorkeeper'

  # glue code for devise and doorkeeper ( core requires devise )
  s.add_dependency 'devise-doorkeeper'

  # Cross-Origin Resource Sharing (CORS); Makes cross-origin AJAX possible.
  s.add_dependency "rack-cors"

  # Use Redis adapter for caching and throttling
  s.add_dependency 'redis', '~> 4.0'

  # lightning fast redis client
  s.add_dependency 'hiredis'

  # Helps to keep thing organized using namespaces in Redis
  s.add_dependency 'redis-namespace'

  # Use a middleware based throttling mechanism
  s.add_dependency 'rack'
  s.add_dependency 'rack-throttle'

  # Documentation.
  s.add_dependency "swagger-docs"

  #### Shared Engine Gems ####

  s.add_dependency "core"

end
