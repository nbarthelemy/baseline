Identity::Engine.routes.draw do
  # Direct the user a login form where they click the link to authenticate
  get '/login', to: 'sessions#new', as: :login

  # Once we get the callback data from the provider we start a session
  get '/auth/:provider/callback', to: 'sessions#create'

  # If it fails
  get '/auth/failure', to: 'sessions#failure'
end