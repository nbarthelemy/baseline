# set environment variables for SSO
Dir[File.join(Rails.root, 'apps', '**/identity.yml')].each do |config|
  app = OpenStruct.new(YAML.load(ERB.new(File.read(config)).result)[Rails.env])
  app_token = app.name.gsub(/[^a-z0-9]+/i,'_').upcase
  ENV["#{app_token}_OAUTH2_UID"] = app.id
  ENV["#{app_token}_OAUTH2_SECRET"] = app.secret
end