Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users do
    resources :favourites
    resources :watches, :path => "watched"     
  end

  get '/movies/related/:id', to: 'movies#related'
  get '/movies/rt/:id', to: 'movies#rt'

  get 'movies/refresh'
  get 'movies/reddit'
  get 'info/registrations'

  get 'home/trakt'

  # Tests
  get 'home/reddit'
  get 'home/apiRTMovieTest'
  get 'home/apiRTTest'
  get 'home/apitest2'
  get 'home/apitest'

  resources :movies

  # match 'users/sign_up', to: 'info#registrations', via: [:get, :post]

  

  root 'movies#index'

end