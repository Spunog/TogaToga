class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def isDev
	    ENV['RAILS_ENV'] == "development"
	end

	def isProd
	    ENV['RAILS_ENV'] == "production"
	end

end
