class MoviesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy, :refresh, :create]
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :related, :reddit, :rt, :traileraddict]

  # GET /movies
  # GET /movies.json
  def index
    per_page = (params.has_key?(:per_page) && params[:per_page].to_i != 0) ? params[:per_page].to_i : 24
    @movies = Movie.joins(:trending).all.page(params[:page]).per_page(per_page)
    @include_header = true
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @userID = (current_user.blank?) ? 0 : current_user.id
    @isUserFavourite = Favourite.where(user_id: @userID, movie_id: @movie.id).count > 0 ? true : false
  end

  def rt
    @rt_critic_reviews = Feed.get_feeds(movie: @movie, site: 'rotten_tomatoes', clear_cache: :true)  
  end

  def traileraddict
    @traileraddict = Feed.get_feeds(movie: @movie, site: 'trailer_addict', clear_cache: :true)  
  end

  def reddit
    @reddit = Feed.get_feeds(movie: @movie, site: 'reddit', clear_cache: :true)
  end

  def related
    @relatedMovies = Movie.related(movie: @movie)
  end

  def christmas
    @movie = Movie.first()
    @christmasList = Feed.get_feeds(movie: @movie, site: 'christmas', clear_cache: :false)
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # GET /movies/refresh - trending videos
  def refresh    
    @result, @processedMovies, @errors = Movie.refresh_listings
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :year, :released, :url, :trailer, :runtime, :tagline, :certification, :imdb_id, :tmdb_id, :poster, :watchers)
    end

end