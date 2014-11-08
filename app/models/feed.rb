class Feed < ActiveRecord::Base
	require 'uri'
	belongs_to :movie
	serialize :jsonData, JSON

	def self.clear_cache(args={})
		site = args[:site]
		movie = args[:movie]

		if movie.feeds.count > 0
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

		if movie.feeds.count < 1
	      # Get new feed
	      redditURL = "http://www.reddit.com/r/movies/search.json?q=subreddit%3Amovies+#{URI.encode(movie.title)}#&restrict_sr=on&sort=relevance&t=all"
	      logger.info "Reddit JSON URL: #{redditURL} "
	      feedData = HTTParty.get(redditURL)

	      # Cache Feed
	      feed = movie.feeds.build
	      feed.site = 'reddit'
	      feed.jsonData = feedData
	      feed.save!
	    else
	      # Use Cache
	      logger.info "Using cache feed for movie: #{movie.title}"
	      feedData = movie.feeds.where(site: 'reddit').first.jsonData
	    end

	    return feedData
	end

	private 

	def self.max_feed_age
		DateTime.now - 4.hours
	end

end