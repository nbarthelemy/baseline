Api::Engine.routes.draw do
  scope constraints: { subdomain: 'api' } do
    namespace :v1 do

      resources :users

    end
  end
end