json.movies do
	json.array!(@relatedMovies) do |movie|
	  json.extract! movie, :id, :title, :overview, :year, :released, :url, :trailer, :runtime, :tagline, :certification, :imdb_id, :poster
	  json.url movie_url(movie, format: :json)
	  json.posterSmallURL movie.posterSmallURL	
	  json.movieurl movie_url(movie)
	end
end