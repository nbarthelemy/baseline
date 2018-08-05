Api::Engine.routes.draw do
  scope constraints: { subdomain: 'api' } do
    namespace :v1 do

      resources :users

    end

    # convenience route for swagger docs
    get '/docs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

  end
end