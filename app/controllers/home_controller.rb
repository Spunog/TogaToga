class HomeController < ApplicationController
  def index
  	# render layout: "superhero"

	@movies = Movie.all


  end
end
