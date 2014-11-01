Rails.application.routes.draw do

  get 'movies/refresh'
  get 'info/registrations'

  get 'home/trakt'
  get 'home/apitest'

  resources :movies

  match 'users/sign_up', to: 'info#registrations', via: [:get, :post]
  devise_for :users

  root 'movies#index'

end