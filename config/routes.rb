Rails.application.routes.draw do

  get '/movies/related/:id', to: 'movies#related'

  get 'movies/refresh'
  get 'movies/rt'
  get 'info/registrations'

  get 'home/trakt'

  # Tests
  get 'home/apiRTMovieTest'
  get 'home/apiRTTest'
  get 'home/apitest2'
  get 'home/apitest'

  resources :movies

  match 'users/sign_up', to: 'info#registrations', via: [:get, :post]
  devise_for :users

  root 'movies#index'

end