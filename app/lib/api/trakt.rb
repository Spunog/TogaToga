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

		def getRelated(id)
			related_uri = BASE_URI + '/movie/related.json/' + @api_key + '/' + id
			HTTParty.get(related_uri)
		end

	end
end