class Movie < ActiveRecord::Base
	has_many :images, dependent: :destroy
	validates_uniqueness_of :imdb_id
	has_many :links, :dependent => :destroy
	has_many :relateds, :through => :links
	has_one :trending

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

end