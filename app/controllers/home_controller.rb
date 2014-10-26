class HomeController < ApplicationController
	before_filter :authenticate_user! #, :except => [:index]

	def index
		# render layout: "superhero"
		@movies = Movie.all
	end
end