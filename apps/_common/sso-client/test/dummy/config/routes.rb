Rails.application.routes.draw do
  mount Sso::Client::Engine => "/sso-client"
end
