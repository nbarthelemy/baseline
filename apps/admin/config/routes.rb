Admin::Engine.routes.draw do
  scope constraints: { subdomain: 'admin' } do

    root 'dashboard#index'

    resource :profile, only: [ :show, :edit, :update ]

  end
end
