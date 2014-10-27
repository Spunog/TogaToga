json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :overview, :year, :released, :url, :trailer, :runtime, :tagline, :certification, :imdb_id, :poster
  json.url movie_url(movie, format: :json)
end
