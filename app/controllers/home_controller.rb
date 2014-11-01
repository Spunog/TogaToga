class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:apitest, :apitest2]
	
	def index
		# render layout: "superhero"
		@movies = Movie.all
	end

	def apitest
		render :layout => false
		request.env['CONTENT_TYPE'] = 'application/json'
	end

	def apitest2
		render :layout => false
		request.env['CONTENT_TYPE'] = 'application/json'
	end

end