class Favourite < ActiveRecord::Base
	belongs_to :user
	belongs_to :movie
	validates_uniqueness_of :movie, :scope => :user
end