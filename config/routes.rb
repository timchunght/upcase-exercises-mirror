Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'

  namespace :admin do
    root to: 'dashboards#show'
    resources :exercises, only: [:index, :new, :create]
  end
end
