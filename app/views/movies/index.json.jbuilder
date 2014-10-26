json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :year, :released, :url, :trailer, :runtime, :tagline, :certification, :imdb_id, :tmdb_id, :poster, :watchers
  json.url movie_url(movie, format: :json)
end
