json.array!(@watches) do |watch|
  json.extract! watch, :id, :movie_id, :user_id
  json.url watch_url(watch, format: :json)
end
