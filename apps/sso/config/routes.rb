Sso::Engine.routes.draw do
  scope constraints: { subdomain: 'sso' } do

    # Installs doorkeeper routes
    use_doorkeeper

    # Installs devise routes for user
    devise_for :users, class_name: 'Sso::User',
      path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      module: :devise

    root to: "home#index"

  end
end
