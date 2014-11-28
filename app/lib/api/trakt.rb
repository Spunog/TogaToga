module Api
	class Trakt
		require "httparty"
		require "uri" 
		# Trending API - api.trakt.tv/movies/trending.json/ENV["TRAKT_API_KEY"]

		BASE_URI = 'http://api.trakt.tv'

		def initialize(args={})
			@api_key = args[:apikey]
		end

		def getTrending
			trending_uri = BASE_URI + "/movies/trending.json/#{URI.encode(@api_key)}"
			HTTParty.get(trending_uri)
		end

		def getRelated(id)
			related_uri = BASE_URI + "/movie/related.json/#{URI.encode(@api_key)}/#{URI.encode(id)}"
			HTTParty.get(related_uri)
		end

		def getChristmsList()
			feed = getUserList('falchie','christmas-movies')
		end

		private

		def getUserList(user,slug)
			related_uri = BASE_URI + "/user/list.json/#{URI.encode(@api_key)}/#{URI.encode(user)}/#{URI.encode(slug)}"
			HTTParty.get(related_uri)
		end

	end
end