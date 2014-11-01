module Api
	class Trakt
		require "httparty"
		# Trending API - api.trakt.tv/movies/trending.json/ENV["TRAKT_API_KEY"]

		BASE_URI = 'http://api.trakt.tv'

		def initialize(args={})
			@api_key = args[:apikey]
		end

		def getTrending
			trending_uri = BASE_URI + '/movies/trending.json/' + @api_key
			HTTParty.get(trending_uri)
		end
		
	end
end