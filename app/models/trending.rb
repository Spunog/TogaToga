class Trending < ActiveRecord::Base
	belongs_to :movie
	validates_presence_of :movie_id
	validates_uniqueness_of :movie_id
	validates_presence_of :rank
	validates_uniqueness_of :rank
	after_initialize :init

	private

	def init
		if self.new_record? && self.rank.nil?
			max_rank = Trending.maximum('rank')
			max_rank = 0 if max_rank.nil?
			self.rank = max_rank + 1
		end
	end

end