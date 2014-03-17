Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'
  get '/auth/failure', to: 'dashboards#show'

  resources :clones, only: :show

  resources :exercises, only: :show do
    resources :clones, only: :create
  end

  namespace :admin do
    root to: 'dashboards#show'
    resources :exercises, only: [:index, :new, :create, :edit, :update]
  end
end
