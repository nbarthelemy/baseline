App::Engine.routes.draw do
  scope constraints: { subdomain: 'app' } do

    devise_for :users, class_name: 'App::User',
      path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      module: :devise

    root 'dashboard#index'

    resource :onboarding, only: [ :new, :create ]
    resource :profile, only: [ :show, :edit, :update ]

    # catch-all static page controllers
    get '/*page' => 'pages#show'
  end
end
