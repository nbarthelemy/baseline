Rails.application.config.middleware.use OmniAuth::Builder do

  # provider :developer unless Rails.env.production?
  # provider :identity, fields: [ :email ], model: Id::Identity, on_failed_registration: lambda {|env|
  #   IdentitiesController.action(:new).call(env)
  # }

end