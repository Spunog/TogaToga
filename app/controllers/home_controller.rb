class HomeController < ApplicationController
	before_filter :authenticate_user!, :except => [:apitest, :apitest2, :apiRTMovieTest, :apiRTTest, :reddit]
	
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

	def apiRTTest
		render :layout => false
		request.env['CONTENT_TYPE'] = 'application/json'
	end

	def apiRTMovieTest
		render :layout => false
		request.env['CONTENT_TYPE'] = 'application/json'
	end

	def reddit
		render :layout => false
		request.env['CONTENT_TYPE'] = 'application/json'
	end

end