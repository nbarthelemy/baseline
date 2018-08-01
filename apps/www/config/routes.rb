Www::Engine.routes.draw do
  scope constraints: { subdomain: 'www' } do

    root "pages#show", page: :index

    # catch-all static page controllers
    get '/*page' => 'pages#show'
  end
end
