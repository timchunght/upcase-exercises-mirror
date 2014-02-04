Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'
end
