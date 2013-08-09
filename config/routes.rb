Rottenpotatoes::Application.routes.draw do
  resources :movies do
      get 'same_director/:title', to: 'movies#same_director', on: :collection, as: :same_director
  end
  # get 'movies/same_director/:director', to: 'movies#same_director'
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
