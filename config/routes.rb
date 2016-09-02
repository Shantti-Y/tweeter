Rails.application.routes.draw do

  get 'follows/following'

  get 'follows/followers'

  # Routes for static_pages
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/reload', to: 'static_pages#reload'

  # Routes for users
  resources 'users'
  get '/signup', to: 'users#new'

  # Routes for sessions
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Routes for account_managements
  get '/account_activation', to: 'account_managements#activation_create'
  get '/password_reset', to: 'account_managements#reset_new'
  post '/password_reset', to: 'account_managements#reset_create'
  get '/password_reset_confirmation', to: 'account_managements#reset_edit'
  patch '/password_reset_confirmation', to: 'account_managements#reset_update'

  # Routes for tweets
  resources 'tweets'

  # Routes for follows
  get '/following/:id', to: 'follows#following', as: :following
  get '/followers/:id', to: 'follows#followers', as: :followers
  resources 'follows', only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
