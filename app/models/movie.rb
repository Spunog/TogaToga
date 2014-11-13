class Movie < ActiveRecord::Base
	has_many :images, dependent: :destroy
	validates_uniqueness_of :imdb_id
	has_many :links, :dependent => :destroy
	has_many :relateds, :through => :links
	has_one :trending
	has_many :feeds, dependent: :destroy

	# Instance Methods

	def released_formatted
		Time.at(self.released).to_datetime.strftime("%d %b %Y")
	end

	def posterThumbnailURL
		posterURL = (self.poster.blank?) ?  "missing_poster.png" : self.poster.gsub(/.jpg/, '-300.jpg')
	end

	def fanartURL

		fanart = self.images.find_by! type_id: 'fanart'
	    if fanart.blank?
	    	fanart = "missing_poster.png"
	    else
			fanart = fanart.url.gsub(/.jpg/,'-940.jpg') # use smaller fan art size for faster loading
	    end

	end

	def posterURL

		poster = self.images.find_by! type_id: 'poster'
	    if poster.blank?
	    	poster = "missing_poster.png"
	    else
			poster = poster.url.gsub(/.jpg/,'-300.jpg') # use smaller fan art size for faster loading
	    end

	end

	def posterSmallURL

		poster = self.images.find_by! type_id: 'poster'
	    if poster.blank?
	    	poster = "missing_poster.png"
	    else
			poster = poster.url.gsub(/.jpg/,'-138.jpg') # use smaller fan art size for faster loading
	    end

	end

	# Class Methods

	def self.refresh_listings

		if ENV['RAILS_ENV'] == "development"
			response = HTTParty.get('http://www.togatoga.me/home/apitest.json') # static json file used for testing
		else
			@trakt = Api::Trakt.new(:apikey => ENV["TRAKT_API_KEY"])
			response = @trakt.getTrending
		end

	    errors = []
	    processedMovies = []
	    result = ''
	    case response.code
	      when 200
	        result = '200 OK'

	        # Clear Existing Trending Movies
	        Trending.destroy_all()

	        # Loop over movies
	        response.each do |movie_item|
	          movie, errorText = Movie.update_or_add_movie(:movie => movie_item, :addRank => true)
	          processedMovies.push(movie.title)
	          errors.push(errorText) if not errorText.blank?
	        end

	      when 404
	        result = '404 Not Found'
	      when 500...600
	        result = "ERROR #{response.code}"
	    end

	    return result, processedMovies, errors

	end

	def self.update_or_add_movie(args={})
      movie_feed = args[:movie]
      addRank = args[:addRank]
      movie = Movie.where(:imdb_id => movie_feed['imdb_id']).first_or_create :title => movie_feed['title']

      begin
        # Main Details
        movie.title         =   movie_feed['title']
        movie.year          =   movie_feed['year']
        movie.released      =   movie_feed['released']
        movie.url           =   movie_feed['url']
        movie.trailer       =   movie_feed['trailer']
        movie.runtime       =   movie_feed['runtime']
        movie.tagline       =   movie_feed['tagline']
        movie.certification =   movie_feed['certification']
        movie.imdb_id       =   movie_feed['imdb_id']
        movie.tmdb_id       =   movie_feed['tmdb_id']
        movie.watchers      =   movie_feed['watchers']

        # Overview
        if movie_feed.has_key?("overview") && !movie_feed['overview'].nil?
          movie.overview      =   movie_feed['overview'].truncate(2000, :length=>2000)
        else
          movie.overview = ''
        end

        # Images - Poster, only update if current movie blank
        if movie.new_record? || movie.poster.blank?
        	movie.poster        =   movie_feed['poster']

	        if movie_feed['images'].has_key?("poster")
	          poster = movie.images.new
	          poster.type_id = 'poster'
	          poster.url = movie_feed['images']['poster']
	        end

	        # Images - Fanart
	        if movie_feed['images'].has_key?("fanart")
	          fanart = movie.images.new
	          fanart.type_id = 'fanart'
	          fanart.url = movie_feed['images']['fanart']
	        end
        end

        # Trending
        movie.build_trending if addRank

        # Save Details
        movie.save!
        errorText = ''

      rescue => e
        # @errors.push("Errors: #{e}")
        errorText = "Errors: #{e}"
      end # end try catch

      return movie, errorText

    end

    def self.related(args={})
    	movie = args[:movie]

		errors = []
	    relatedMovies = []

	    cachedRelatedMovies = movie.relateds

	    if cachedRelatedMovies.count > 0
	      relatedMovies = cachedRelatedMovies
	    else
	      # Related Movies 
	      if ENV['RAILS_ENV'] == "development"
	        response = HTTParty.get('http://localhost:3000/home/apitest2.json') # static json file used for testing
	      else
	      	trakt = Api::Trakt.new(:apikey => ENV["TRAKT_API_KEY"])
	        response = trakt.getRelated(movie.imdb_id)
	      end

	      if response.code == 200
	          response.each do |movie_item|
	            movie, errorText = update_or_add_movie(:movie => movie_item, :addRank => false)
	            relatedMovies.push(movie)
	            errors.push(errorText) if not errorText.blank?
	          end
	      end
	    end

	    return relatedMovies
    end

end