Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'
  get '/auth/failure', to: 'dashboards#show'

  resources :exercises, only: :show do
    resource :clone, only: [:create, :show]
    resources :solutions, only: [:create, :show]
  end

  resources :solutions, only: [] do
    resources :comments, only: [:create]
  end

  namespace :admin do
    root to: 'dashboards#show'
    resources :exercises, only: [:index, :new, :create, :edit, :update]
  end
end
