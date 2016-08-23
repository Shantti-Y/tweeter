Rails.application.routes.draw do

  # Routes for static_pages
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'

  # Routes for users
  resources 'users'
  get '/signup', to: 'users#new'

  # Routes for sessions
  get '/login', to: 'static_pages#home'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Routes for account_managements
  get '/account_activation', to: 'account_managements#activation_create'
  get '/password_reset', to: 'account_managements#reset_new'
  post '/password_reset', to: 'account_managements#reset_create'
  get '/password_reset_confirmation', to: 'account_managements#reset_edit'
  patch '/password_reset_confirmation', to: 'account_managements#reset_update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
