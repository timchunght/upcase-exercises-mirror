Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'

  get "/pages/*id" => 'pages#show', as: :page, format: false

  resources :exercises, only: :show

  namespace :admin do
    root to: 'dashboards#show'
    resources :exercises, only: [:index, :new, :create, :edit, :update]
  end
end
