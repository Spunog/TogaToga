class Movie < ActiveRecord::Base
	has_many :images, dependent: :destroy
	validates_uniqueness_of :imdb_id
	has_many :links, :dependent => :destroy
	has_many :relateds, :through => :links

	def released_formatted
		Time.at(self.released).to_datetime.strftime("%d %b %Y")
	end

end