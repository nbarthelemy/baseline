Id::Engine.routes.draw do
  scope constraints: { subdomain: 'id' } do

    scope module: :id do
      root to: "sessions#new"

      get "/auth/:provider/callback", to: "sessions#create"
      get "/auth/failure", to: "sessions#failure"
      get "/logout", to: "sessions#destroy", as: "logout"

      resources :identities
    end

  end
end
