Api::Engine.routes.draw do
  scope constraints: { subdomain: 'api' } do
    scope defaults: { format: :json } do

      # Installs doorkeeper oauth routes
      use_doorkeeper do
        skip_controllers :applications, :authorized_applications
      end

      devise_for :users, class_name: 'Api::User',
        controllers: {
          registrations: 'api/registrations'
        }, skip: [ :sessions, :password ],
        module: :devise

      # create the api endpoints in the correct scope
      scope module: :api do
        namespace :v1 do
          get '/me', to: 'credentials#me'

          resources :users
        end
      end

    end

    # convenience route for swagger docs
    root to: redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

  end
end