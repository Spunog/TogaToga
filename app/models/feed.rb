class Feed < ActiveRecord::Base
	require 'uri'
	belongs_to :movie
	serialize :jsonData, JSON

	def self.clear_cache(args={})
		site = args[:site]
		movie = args[:movie]

		if movie.feeds.where(site: site).count > 0
			feeds_to_remove = movie.feeds.where("site = ? AND created_at <= ?", :site, self.max_feed_age)
			logger.info "Remove old cache for #{movie.title}. Total: #{feeds_to_remove.count}"
			feeds_to_remove.destroy_all
		end

	end

	def self.get_feeds(args={})
		site = args[:site]
		movie = args[:movie]
		clear_cache = args[:clear_cache]

		if clear_cache
			Feed.clear_cache(site: site, movie: movie)
		end

		if movie.feeds.where(site: site).count < 1
			# No cached version exists, fetch new data

			case site
			when "trailer_addict"
				imdb_id = (movie.imdb_id.blank?) ?  "" : movie.imdb_id.gsub(/tt/, '')
				feedURL = "http://api.traileraddict.com/?count=4&width=000&imdb=#{URI.encode(imdb_id)}"
	      		logger.info "trailer addict JSON URL: #{feedURL} "
	      		feedData = HTTParty.get(feedURL)
			when "christmas"
				logger.info "Fetching new Christmas data using Trakt API"
				trakt_api = Api::Trakt.new(:apikey => ENV["TRAKT_API_KEY"])    
				feedData = trakt_api.getChristmsList()
			when "reddit"
				feedURL = "http://www.reddit.com/r/movies/search.json?q=subreddit%3Amovies+#{URI.encode(movie.title)}#&restrict_sr=on&sort=relevance&t=all"
	      		logger.info "Reddit JSON URL: #{feedURL} "
	      		feedData = HTTParty.get(feedURL)
			when "rotten_tomatoes"
			    rotten_tomato_api = Api::Rotten_Tomatoes.new(:apikey => ENV["ROTTEN_TOMATOES_API_KEY"])    
			    
			    # Get Rotten Tomatoes ID
			    rt_movie = rotten_tomato_api.find_movie_by_imdb_id(movie.imdb_id)
			    rt_id = rt_movie['id']

			    # Get Reviews
			    feedData = rotten_tomato_api.top_critic_reviews_for_movie(rt_id)
			    feedData["movie"] = rt_movie
			    logger.info "========= Rotten Tomatoes JSON Live Fetch Complete ========="
			end

	      # Cache Feed
	      feed = movie.feeds.build
	      feed.site = site
	      feed.jsonData = feedData
	      feed.save!
	    else
	      # Use Cached version
	      logger.info "========= Using cache feed for movie: #{movie.title} ========="
	      feedData = movie.feeds.where(site: site).first.jsonData
	    end

	    return feedData
	end

	private 

	def self.max_feed_age
		DateTime.now - 6.hours
	end

end