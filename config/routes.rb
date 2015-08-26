Rails.application.routes.draw do
  resources :projects
  post '/projects/:id/star' => 'projects#star'
  post '/projects/:id/unstar' => 'projects#unstar'

  resources :users
  root to: 'projects#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  get '/github/authorize/' => 'github#authorize'
  get '/github/callback/' => 'github#callback'
end
