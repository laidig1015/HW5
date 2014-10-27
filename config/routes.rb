Rottenpotatoes::Application.routes.draw do
  resources :movies
  match 'movies/search_tmdb', to: 'movies#search_tmdb', via: :post
  match 'movies/movies/search_tmdb', to: 'movies#search_tmdb', via: :post
  match 'movies/add_tmdb', to: 'movies#add_tmdb', via: :post
  match 'movies/movies/add_tmdb', to: 'movies#add_tmdb', via: :post
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end
