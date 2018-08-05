App::Engine.routes.draw do
  scope constraints: { subdomain: 'app' } do

    root 'dashboard#index'

    resource :onboarding, only: [ :new, :create ]
    resource :profile, only: [ :show, :edit, :update ]

    # catch-all static page controllers
    get '/*page' => 'pages#show'
  end
end
