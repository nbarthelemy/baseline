Id::Engine.routes.draw do
  scope constraints: { subdomain: 'id' } do

    # Installs doorkeeper oauth routes
    use_doorkeeper scope: :doorkeeper

    # Installs devise routes for user
    devise_for :users, class_name: 'Id::User',
      path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      module: :devise

    namespace :api do
      namespace :v1 do
        get '/me' => 'credentials#me'
      end
    end

    root to: "home#index"

  end
end
